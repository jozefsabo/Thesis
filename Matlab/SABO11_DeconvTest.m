global_settings;

psf_size  = 15; 
pad_up    = floor(psf_size/2); 
pad_down  = psf_size - pad_up - 1; 

iso_base  = 100; 
iso_noise = 1600; 


u           = im2double(imread('lena256.png')); 
h_in        = imresize(im2double(imread('blur_kernel_6.png')),[psf_size psf_size], 'lanczos3');
h_in        = h_in + abs(min(h_in(:))); 
h_in        = h_in / sum(h_in(:)); 


g2          = OJAL08_CameraNoiseSimulation(im_orig, iso_noise);
g1          = OJAL08_CameraNoiseSimulation(conv2_ext(im_orig, in_kernel), iso_base);

g1_vec      = reshape (g1', 1, []); 

g1_pad      = image_pad(im_noise, pad_up, pad_down, pad_up, pad_down); 



G1 = conv2mult(g1, h_in); 
G2 = conv2mult(g2, h_in); 


A = G2'*G2; 
b = 








































