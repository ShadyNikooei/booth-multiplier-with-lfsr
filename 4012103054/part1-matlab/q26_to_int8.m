function y = q26_to_int8(x)
% q26_to_int8  Quantize real x in [-1, +1] to signed Q2.6 as int8 (scaled by 2^6).
% saturates outside the representable range.
    FL = 6; SCALE = 2^FL;
    % limit to Q2.6 numeric range: [-2, 2 - 2^-6], but inputs are in [-1,1]
    xi = round(x * SCALE);
    xi = max(min(xi,  127), -128);   % int8 range
    y  = int8(xi);
end
