%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preparation the blurred - noisy image pair %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% img_input - input image
%%% psf_input - input PSF 
%%% psf_size  - input PSF size
%%% blur_iso  - blurred image ISO
%%% noise_iso - noisy image ISO
%%% img_noise - the prepared noisy image
%%% img_blur  - the prepared blurred image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [img_noise img_blur] = SABO11_PrepareSimulationData(img_input, psf_input, psf_size, blur_iso, noise_iso)

	blur_kernel           = imresize(psf_input, (psf_size / max(size(psf_input,1),size(psf_input,2))), 'lanczos3'); 
	blur_kernel_sum       = sum(blur_kernel(:));  

	img_blur              = conv2_ext(img_input, blur_kernel ./ blur_kernel_sum); 

	img_noise             = OJAL08_CameraNoiseSimulation(img_input, noise_iso); 
	img_blur              = OJAL08_CameraNoiseSimulation(img_blur , blur_iso );

end