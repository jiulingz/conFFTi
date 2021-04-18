init:
	@vlog -sv -svinputport=var ../../../includes/*

sim:
ifeq ($(TEST),)
	@echo -e "Specify a test.\n\tmake sim TEST=<test name>"
else
	@vsim -c -do "run -all" $(TEST)
endif

INCLUDES="+define+CONFIG_VH_ +define+MIDI_VH_ +define+PARAMETER_VH_ +define+OSCILLATOR_VH_"
%_test:
	@vlog $(INCLUDES) +define+SIMULATION -sv -svinputport=var $^
