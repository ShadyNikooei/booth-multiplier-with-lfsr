function y_int8 = prod_int16_to_q26_int8(p_int16)
% prod_int16_to_q26_int8  Convert int16 product (scaled by 2^12) back to Q2.6 int8.
% - Arithmetic shift-right by 6 (with rounding) and saturate to int8.
    FL = 6;
    % rounding: add/sub half-LSB before shift
    add = int32(sign(p_int16)) * int32(2^(FL-1));
    tmp = int32(p_int16) + add;
    xi  = bitsra(tmp, FL);              % arithmetic shift right by FL
    xi  = max(min(xi,  127), -128);     % saturate to int8
    y_int8 = int8(xi);
end

function s = sign(x)
% local helper: returns -1,0,+1 as int32
    s = int32( (x>0) ) - int32( (x<0) );
end
