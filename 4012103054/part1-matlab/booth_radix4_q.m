function prod_int16 = booth_radix4_q(a_int8, b_int8, WL)
% booth_radix4_q  Radix-4 Booth multiplier on signed, scaled integers.
% Inputs:
%   a_int8, b_int8 : int8 operands representing Q2.6 values (scaled by 2^6)
%   WL             : word length (8 for Q2.6 here)
% Output:
%   prod_int16     : int16 product (scaled by 2^(2*6) = 2^12)
%
% Notes:
% - This core does *integer* Booth on two's-complement ints.
% - Accumulator keeps 32-bit for safety; final saturates to int16.
%
% Mapping to Q2.6:
%   real(a) = a_int8 / 2^6 ; same for b
%   real(product) = (prod_int16 / 2^12)
% To *return to Q2.6 int8*, later divide by 2^6 with rounding & saturate.

    A = int16(a_int8);
    B = int16(b_int8);

    % build {sign, B, 0} bit vector in LSB..MSB order
    b_bits = zeros(WL+2,1,'int16');
    for k = 1:WL
        b_bits(k) = bitand(bitshift(B, -(k-1)), int16(1));
    end
    b_bits(WL+1) = b_bits(WL);   % sign extend
    b_bits(WL+2) = 0;            % trailing 0

    acc  = int32(0);
    A32  = int32(A);
    groups = ceil(double(WL)/2);

    for i = 0:(groups-1)
        idx = 2*i + 1;
        sel = b_bits(idx) + 2*b_bits(idx+1) + 4*b_bits(idx+2); % 0..7
        switch sel
            case {0,7} % 000,111
                term = int32(0);
            case {1,2} % +A
                term = A32;
            case 3     % +2A
                term = bitshift(A32, 1);
            case 4     % -2A
                term = -bitshift(A32, 1);
            case {5,6} % -A
                term = -A32;
            otherwise
                term = int32(0);
        end
        acc = bitshift(acc, 2) + term;   % shift by 2 between groups
    end

    % saturate to int16
    acc = max(min(acc, int32(intmax('int16'))), int32(intmin('int16')));
    prod_int16 = int16(acc);
end
