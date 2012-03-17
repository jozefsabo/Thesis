%Testing ground for Tico's method (2007)
clear; 
clc; 

global g1 g2 lambda1 lambda2 alpha beta1 beta2 a b gamma N;

sig1     = 0.005; 
sig2     = 0.0001; 
psf_size = 32; 

a        = 4; 
b        = 1; 

beta1    = 1; 
beta2    = 1; 
lambda1  = sqrt(sig1); 
lambda2  = sqrt(sig2); 

N        = prod(size(g1)); 


[f g0 g2 g1 k] = prepare_test_data_simple('lena2.png', 'blur_kernel_1.png', sig1, sig2, psf_size); 

%g2 = g2 / sqrt(var(g2(:))); 
%g1 = g1 / sqrt(var(g1(:))); 

alpha    = mean(g1(:)) / mean(g2(:)); 


[v g] = TICO07_2_PotFunc(g1, zeros(psf_size), zeros(psf_size)); 



