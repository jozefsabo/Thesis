%Shift values for convolution padding
%blur_kernel           - blur PSF
%up, down, left, right - respective shift values 
function [up down left right] = conv2_shifts(blur_kernel)

	up    = floor(size(blur_kernel, 1) / 2); 
	down  = size(blur_kernel,  1) - up - 1; 

	left  = floor(size(blur_kernel, 2) / 2); 
	right = size(blur_kernel,  2) - left - 1; 


end 