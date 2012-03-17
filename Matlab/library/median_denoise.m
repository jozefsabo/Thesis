%Wrapper function for medfilt

function out_img = median_denoise(in_img, mask_size)
	
	out_img = (medfilt2(in_img, [mask_size mask_size]) + in_img) / 2; 
	
end