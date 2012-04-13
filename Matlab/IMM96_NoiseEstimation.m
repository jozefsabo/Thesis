%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise estimation method by Immerkaer (1996) %%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% img_noise - the noisy image
%%% est_sig   - the estimated noise standard dev. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function est_sig = IMM96_NoiseEstimation(img_noise)

	[h w]   = size(img_noise); 
	lap     = [1  -2  1; -2  4 -2;  1 -2  1];    
	img_lap = abs(conv2_ext(img_noise, lap));  
	est_sig = sqrt(pi/2)*sum(img_lap(:)) ./ (6 * (w - 2) * (h - 2)); 
    
end
