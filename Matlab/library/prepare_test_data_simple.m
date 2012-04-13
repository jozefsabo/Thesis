%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prepare simple test data, i.e. noisy image & blurred and less noisy image %%%
%%% using gaussian noises with zero means                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%% image_path          - path to input image
%%% psf_path            - path to input blur PSF
%%% noise_var           - desired noisy image variance
%%% blur_var            - desired blurred image variance
%%% psf_size            - desired PSF blur size
%%% original_image      - the original image
%%% blurred_clean_image - blurred image without noise
%%% blurred_noisy_image - blurred image with noise
%%% noisy_image         - noisy image
%%% blur_kernel         - loaded blur kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [original_image blurred_clean_image blurred_noisy_image noisy_image blur_kernel] = prepare_test_data_simple(image_path, psf_path, noise_var, blur_var, psf_size)

	original_image        = im2double(imread(image_path)); 
	blur_kernel           = im2double(imread(psf_path));
	blur_kernel           = imresize(blur_kernel, (psf_size / max(size(blur_kernel,1),size(blur_kernel,2))), 'lanczos3'); 
	blur_kernel_sum       = sum(blur_kernel(:));  

	blurred_clean_image   = conv2_ext(original_image, blur_kernel ./ blur_kernel_sum); 

	noisy_image           = imnoise(original_image     , 'gaussian', 0, noise_var); 
	blurred_noisy_image   = imnoise(blurred_clean_image, 'gaussian', 0, blur_var ); 

end