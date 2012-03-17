%TICO09 Test 2
clear;
clc;

tico09_blur  = im2double(imread('tico09_blur_cut_512.png'));
tico09_noise = im2double(imread('tico09_noise_cut_512.png'));
tico09_result= im2double(imread('tico09_result_cut_512.png'));
%noise standard deviation estimation
est_sig      = sqrt(TICO09_NoiseVarianceEstimation(tico09_noise)); 

sabo11_result    = SABO11_MergeExperiment(tico09_blur, tico09_noise); 
medflt_result    = medfilt2(tico09_noise, [5 5]);
tico09_exper     = TICO09_LuminanceFusion(tico09_blur, tico09_noise); 
[NA bm3d_result] = BM3D(1, tico09_noise, est_sig * 255); 

fprintf('TICO09 programmed. SNR: %6.4f\n',eval_snr(tico09_result, tico09_exper )); 
fprintf('SABO11 programmed. SNR: %6.4f\n',eval_snr(tico09_result, sabo11_result)); 
fprintf('BM3D    denoising. SNR: %6.4f\n',eval_snr(tico09_result, bm3d_result  )); 
fprintf('Median  filtering. SNR: %6.4f\n',eval_snr(tico09_result, medflt_result)); 

imwrite(sabo11_result, 'sabo11_result.png', 'png'); 
imwrite(medflt_result, 'medflt_result.png', 'png'); 
imwrite(tico09_result, 'tico09_exper.png', 'png');
imwrite(bm3d_result  , 'bm3d_result .png', 'png');


%putimages(tico09_blur, tico09_noise, tico09_result, tico09_exper, sabo11_result, medflt_result); 