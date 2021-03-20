// reference: https://github.com/AlexSunNik/ECE385-Final-Project/blob/master/audioController.sv

module audioController (
	logic input         clk, reset, SW0,
	logic inout         SDIN,
	logic input  [ 7:0] mixer_output, // where data is coming in, 8-bit data for now, could be adjusted
	logic output        SCLK,
  logic output        USB_clk, BCLK,
	logic output        DAC_LR_CLK,
	logic output        DAC_DATA
);

  logic         [ 3:0] counter; //selecting register address and its corresponding data
  logic                counting_state, ignition, read_enable; 	
  logic         [15:0] MUX_input;
  logic         [ 3:0] ROM_output_mux_counter;
  logic         [ 4:0] DAC_LR_CLK_counter;
  logic         [15:0] ROM_out_BUF;
  logic         [15:0] ROM_out;
  logic                finish_flag;

  assign DAC_DATA = (SW0) ? ROM_out[15 - ROM_output_mux_counter] : 0;

  //============================================
  // Instantiation section
  //============================================

  I2C_Protocol I2C (
    .clk(clk),
    .reset(reset),
    .ignition(ignition),
    .MUX_input(MUX_input),
    .ACK(),
    .SDIN(SDIN),
    .finish_flag(finish_flag),
    .SCLK(SCLK)
  );

  USB_Clock_PLL	USB_Clock_PLL_inst (
    .inclk0 (clk),
    .c0 (USB_clk),
    .c1 (BCLK)
  );

  //============================================
  // Left and right channel DATA assembly
  //============================================

  logic [3:0] bitcounter;

  // TODO: figure out if this is right
  always_ff @(posedge clk)
    begin
      bitcounter <= bitcounter + 1;
      if (bitcounter == 5) ROM_out_BUF[15:8] <= mixer_output;
      if (bitcounter == 12) ROM_out_BUF[7:0] <= mixer_output;
      if (bitcounter == 14) bitcounter <= 0;
    end

  always_ff @(posedge DAC_LR_CLK)
    begin
      if (read_enable)
        ROM_out <= ROM_out_BUF;
    end

  //============================================
  // ROM output mux
  //============================================

  always_ff @(posedge BCLK) 
    begin
    if (read_enable)
      begin
        ROM_output_mux_counter <= ROM_output_mux_counter + 1;
        if (DAC_LR_CLK_counter == 1) fast_LR_CLK <= 1;
        else fast_LR_CLK <= 0;
        if (DAC_LR_CLK_counter == 31) DAC_LR_CLK <= 1;
        else DAC_LR_CLK <= 0;
      end
    end
    
  always_ff @(posedge BCLK)
    begin
    if (read_enable)
      begin
        DAC_LR_CLK_counter <= DAC_LR_CLK_counter + 1;
      end
    end

  //============================================
  // generate 6 configuration pulses
  //============================================

  // TODO: draw FSM
  always_ff @(posedge clk)
    begin
    if (!reset) 
      begin
        counting_state <= 0;
        read_enable <= 0;
      end
    else
      begin
        case (counting_state)
        0:
          begin
            ignition <= 1;
            read_enable <= 0;
            if (counter == 8) counting_state <= 1; //was 8
          end
        1:
          begin
            read_enable <= 1;
            ignition <= 0;
          end
        endcase
      end
    end

  //============================================
  // this counter is used to switch between registers
  //============================================
  // TODO: understand
  always_ff @(posedge SCLK)
    begin
      case (counter) //MUX_input[15:9] register address, MUX_input[8:0] register data
        0: MUX_input <= 16'h1201; // activate interface
        1: MUX_input <= 16'h0460; // left headphone out
        2: MUX_input <= 16'h0C00; // power down control
        3: MUX_input <= 16'h0812; // analog audio path control
        4: MUX_input <= 16'h0A00; // digital audio path control
        5: MUX_input <= 16'h102F; // sampling control
        6: MUX_input <= 16'h0E23; // digital audio interface format
        7: MUX_input <= 16'h0660; // right headphone out
        8: MUX_input <= 16'h1E00; // reset device
      endcase
    end
  always_ff @(posedge finish_flag)
    begin
      counter <= counter + 1;
    end

endmodule 