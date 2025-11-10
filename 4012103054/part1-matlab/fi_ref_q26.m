function y = fi_ref_q26(a_real, b_real)
% fi_ref_q26  Reference Q2.6 product using MATLAB Fixed-Point (fi).
% returns numeric double of Q2.6-quantized result.
    WL = 8; FL = 6; S = 1;
    fm = fimath('RoundingMethod','Nearest','OverflowAction','Saturate', ...
                'ProductMode','FullPrecision','SumMode','FullPrecision');
    a_q = fi(a_real, S, WL, FL, 'fimath', fm);
    b_q = fi(b_real, S, WL, FL, 'fimath', fm);
    p_full = a_q * b_q;                            % Q4.12
    p_q26  = fi(p_full, S, WL, FL, 'fimath', fm);  % back to Q2.6
    y = double(p_q26);
end
