% Demo: Booth Radix-4 for 8-bit Q2.6 fixed-point, plus accuracy vs fi reference.

clear;
clc; 
rng(1);

% Q2.6
WL = 8; 
FL = 6; 

% number of random test samples in [-1, +1]
Ns = 2000;               

% single example
a_real = 0.37; 
b_real = -0.62;

% scale/quantize to Q2.6(int8)
a_int8 = q26_to_int8(a_real);    
b_int8 = q26_to_int8(b_real);


% core Booth on scaled ints
p_int16 = booth_radix4_q(a_int8, b_int8, WL);   

% back to Q2.6 int8
p_q26_int8 = prod_int16_to_q26_int8(p_int16); 

% numeric value of Q2.6
p_q26_real = double(p_q26_int8) / 2^FL;   

% fi (Q2.6)
ref_q26 = fi_ref_q26(a_real, b_real);           

fprintf('Single:\n  a=%.6f  b=%.6f\n  booth(Q2.6)=%.6f  ref(fi Q2.6)=%.6f\n\n', ...
        a_real, b_real, p_q26_real, ref_q26);

% vector test for MAE/MSE
a_vec = 2*rand(Ns,1) - 1;       % in [-1, +1]
b_vec = 2*rand(Ns,1) - 1;

a_i8  = arrayfun(@q26_to_int8, a_vec);
b_i8  = arrayfun(@q26_to_int8, b_vec);

p_i16 = arrayfun(@(x,y) booth_radix4_q(x,y,WL), a_i8, b_i8);
p_i8  = arrayfun(@prod_int16_to_q26_int8, p_i16);

% numeric values (Q2.6 divide by 2^6)
p_booth = double(p_i8) / 2^FL;

% fi (Q2.6)
ref_vec = arrayfun(@fi_ref_q26, a_vec, b_vec);

err = p_booth - ref_vec;
MAE = mean(abs(err));
MSE = mean(err.^2);

fprintf('Batch (Ns=%d): MAE = %.6g , MSE = %.6g\n', Ns, MAE, MSE);

% Quick plot for first 50 samples
figure;
subplot(2,1,1);
plot(1:50, ref_vec(1:50), '-o'); hold on;
plot(1:50, p_booth(1:50), '-x'); grid on;
title('First 50 products (Q2.6)'); legend('fi ref','Booth');
subplot(2,1,2);
stem(1:50, err(1:50), 'filled'); grid on; title('Error (Booth - ref)');
xlabel('sample'); ylabel('error');
