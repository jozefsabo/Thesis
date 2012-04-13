%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluate SNR according to Šroubek by meabs of a sliding window %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% I        - original image 
%%% E        - estimated imagte (same size as I)
%%% psf_size - size of the scanning window
%%% best_snr - best obtained SNR value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function best_snr = eval_sroubek_snr_shift(I,E,psf_size)
	
	results = zeros(psf_size,psf_size);  
	% seek height and width
	seekH   = size(E,1) - psf_size + 1; 
	seekW   = size(E,2) - psf_size + 1;
	% cut out center of the estimated image
	seekE   = E( (1:seekH) + floor(psf_size/2),  (1:seekW) + floor(psf_size/2)); 
	
	for i=1:psf_size
		for j=1:psf_size
			results(i,j) = eval_sroubek_snr(I( (1:seekH) + i - 1, (1:seekW) + j - 1), seekE);  
		end
	end	
	
	best_snr = max(results(:)); 
	
	clear seekE; 
	clear results; 
end

