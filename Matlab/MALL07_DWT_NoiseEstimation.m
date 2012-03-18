%Estimate noise variance from an image according to Mallat (2007)
%in_img  - input image
%est_var - estimated noise variance
function [est_sig] = MALL07_DWT_NoiseEstimation(in_img)
    
	[coefs, sizes]  = wavedec2(in_img,1,'bior1.1');

	low_index       = sizes(1,1)*sizes(1,2) + 1;
	high_index      = sizes(1,1)*sizes(1,2) + 3*sizes(2,1)*sizes(2,2);
	wavelet_coefs   = (coefs (1, low_index:high_index)) ;
	coef_median     = median(abs(wavelet_coefs - median(wavelet_coefs)));     
	est_sig         = coef_median / 0.6745 ;

end
