% tap reference: https://www.xilinx.com/support/documentation/application_notes/xapp052.pdf, Table 3

function q = lfsr()
    N = 16;
    RESET_VAL = zeros(1, N);
    TAPS = [16, 15, 13, 4];

    persistent s;
    if isempty(s)
        s = RESET_VAL;
    end

    q = 0;
    for i = TAPS
        q = bitxor(q, s(i));
    end
    q = ~q;

    s = [q, s(1:15)];

end
