%TICO07 Test 2
global_settings; 


tico07_orig  = im2double(imread('cameraman_tico07_cut_239_resize_256.png'));
tico07_blur  = im2double(imread('tico07_blur_orig_cut_239_resize_256.png'));
tico07_noise = im2double(imread('tico07_noise_orig_cut_239_resize_256.png'));
tico07_result= im2double(imread('tico07_result_orig_cut_239_resize_256.png'));
%noise standard deviation estimation
est_sig      = MALL07_SWT_NoiseEstimation(tico07_noise); 

sabo11_result    = SABO11_MergeExperiment(tico07_blur, tico07_noise); 
medflt_result    = medfilt2(tico07_noise, [5 5]);
tico09_exper     = TICO09_LuminanceFusion(tico07_blur, tico07_noise); 
[NA bm3d_result] = BM3D(1, tico07_noise, est_sig * 255); 

fprintf('TICO07 original. SNR: %6.4f\n'  , eval_snr(tico07_orig, tico07_result  )); 
fprintf('TICO07 noise. SNR: %6.4f\n'     , eval_snr(tico07_orig, tico07_noise   )); 
fprintf('TICO07 blurred. SNR: %6.4f\n'   , eval_snr(tico07_orig, tico07_blur )); 
fprintf('TICO09 programmed. SNR: %6.4f\n', eval_snr(tico07_orig, tico09_exper   )); 
fprintf('SABO11 programmed. SNR: %6.4f\n', eval_snr(tico07_orig, sabo11_result  )); 
fprintf('BM3D    denoising. SNR: %6.4f\n', eval_snr(tico07_orig, bm3d_result    )); 
fprintf('Median  filtering. SNR: %6.4f\n', eval_snr(tico07_orig, medflt_result  )); 



imwrite(sabo11_result, 'tico07_sabo11_result.png', 'png'); 
imwrite(medflt_result, 'tico07_medflt_result.png', 'png'); 
imwrite(tico09_exper, 'tico07_tico09_exper.png', 'png');
imwrite(bm3d_result  , 'tico07_bm3d_result .png', 'png');


%putimages(tico09_blur, tico09_noise, tico09_result, tico09_exper, sabo11_result, medflt_result); 