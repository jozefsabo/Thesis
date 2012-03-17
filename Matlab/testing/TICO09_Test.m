%TICO09 test
clear; 
clc;

iso_numbers  = [200 400 800 1600 3200 6400]; 
kernel_sizes = [1   2   3   5    10   20  ];  

%iso_numbers  = [6400];
%kernel_sizes = [20]; 

for i = 1:(size(iso_numbers, 2)) 
    
    [original_image blurred_image blurred_noisy_image noisy_image blur_kernel] = SABO10_GenerateSimulationData('lena4.png', 'blur_kernel_6.png', iso_numbers(i), 100 , kernel_sizes(i)); 

    %kano09_image     = KANO09_ImageFusion      (blurred_noisy_image, noisy_image, kernel_sizes(i)); 
    %vekk10_image     = VEKK10_ImageFusion      (blurred_noisy_image, noisy_image);  
    tico09_image     = TICO09_LuminanceFusion   (blurred_noisy_image, noisy_image); 
    sabo11_image     = SABO11_MergeExperiment   (blurred_noisy_image, noisy_image); 
    
    est_sig(i)       = sqrt(TICO09_NoiseVarianceEstimation(noisy_image));  
    est_sig_255      = est_sig(i)*255; 

    [NA, bm3d_image] = BM3D(1, noisy_image, est_sig(i)*255); 

    %snr_results(1:3,i) =  [eval_snr(original_image, blurred_noisy_image), eval_snr(original_image, noisy_image), eval_snr(original_image, tico09_image)];  
    %snr_results(1:4,i) =  [eval_snr(original_image, blurred_noisy_image), eval_snr(original_image, noisy_image), eval_snr(original_image, tico09_image), eval_snr(original_image, bm3d_image)];  
    %snr_results(1:4,i) =  [eval_snr(original_image, blurred_noisy_image), eval_snr(original_image, noisy_image), eval_snr(original_image, tico09_image), eval_snr(original_image, sabo11_image)];  
    snr_results(1:5,i) =  [eval_snr(original_image, blurred_noisy_image), eval_snr(original_image, noisy_image) , eval_snr(original_image, tico09_image)       , eval_snr(original_image, sabo11_image), eval_snr(original_image, bm3d_image)];  
    %snr_results(1:7,i) =  [eval_snr(original_image, blurred_noisy_image), eval_snr(original_image, noisy_image) , eval_snr(original_image, tico09_image)       , eval_snr(original_image, sabo11_image), eval_snr(original_image, vekk10_image), eval_snr(original_image, kano09_image), eval_snr(original_image, bm3d_image)];  

    
    
    imwrite(blurred_noisy_image, sprintf('blurred_image_PSF_%02d_ISO_%04d.png'      , kernel_sizes(i), iso_numbers(i)), 'png'); 
    imwrite(noisy_image        , sprintf('noisy_image_PSF_%02d_ISO_%04d.png'        , kernel_sizes(i), iso_numbers(i)), 'png'); 
    imwrite(tico09_image       , sprintf('TICO09_result_image_PSF_%02d_ISO_%04d.png', kernel_sizes(i), iso_numbers(i)), 'png'); 
    imwrite(bm3d_image         , sprintf('BM3D_result_image_PSF_%02d_ISO_%04d.png'  , kernel_sizes(i), iso_numbers(i)), 'png'); 
    imwrite(sabo11_image       , sprintf('sabo11_result_image_PSF_%02d_ISO_%04d.png', kernel_sizes(i), iso_numbers(i)), 'png'); 
    %imwrite(vekk10_image      , sprintf('vekk10_result_image_PSF_%02d_ISO_%04d.png', kernel_sizes(i), iso_numbers(i)), 'png'); 

    
end    
    
%print SNR results
snr_results
%print estimated sigmas
est_sig




