noise_std = 0.005; 

I = im2double(imread('lena4.tif')); 
I = imnoise(I, 'gaussian', 0, noise_std^2);  

% Wavelet decomposition
[coefs , sizes ] = wavedec2(I , wmaxlev([size(I,  1) size(I , 2)], 'db10'), 'db10'); 

width  = sizes(size(sizes, 1) - 1, 2); 
height = sizes(size(sizes, 1) - 1, 1); 

%finest detail
med_1  = median(coefs(size(coefs, 2) - width*height: end)) 
med_2  = median(abs(coefs(size(coefs, 2) - width*height: end) - med_1))

%all coefficients
%med_1  = median(coefs(1: end)); 
%med_2  = median(abs(coefs(1: end) - med_1));

est_std = med_2 * 1.4826

imshow(I);