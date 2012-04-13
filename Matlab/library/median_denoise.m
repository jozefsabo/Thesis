%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Remove noise using MATLAB's medfilt2 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% in_img    - input image
%%% mask_size - median filtering mask size
%%% out_img   - output image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_img = median_denoise(in_img, mask_size)
	
	out_img = (medfilt2(in_img, [mask_size mask_size]) + in_img) / 2; 
	
end