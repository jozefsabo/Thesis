%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise estimation method by Mallat (2009) using the undecimated wavelet transform %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% in_img  - input image
%%% est_sig - estimated noise standard deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [est_sig] = MALL09_SWT_NoiseEstimation(in_img)
    
	[A H V D]       = swt2(in_img,1,'bior1.1');

    [img_y img_x]   = size(in_img);  
     img_a          = img_x * img_y; 
    
    wavelet_coefs   = zeros(1, 3*img_a); 
     
    wavelet_coefs(1          :   img_a ) = H(:); 
    wavelet_coefs(  img_a + 1: 2*img_a ) = V(:); 
    wavelet_coefs(2*img_a + 1: 3*img_a ) = D(:); 
    
	coef_median     = median(abs(wavelet_coefs - median(wavelet_coefs)));     
	est_sig         = coef_median / 0.6745 ;

end