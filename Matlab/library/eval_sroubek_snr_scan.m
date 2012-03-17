function best_snr = eval_sroubek_snr_scan(I,E)
	
	psf_size = size(I,1) - size(E,1) + 1; 
	
	results = zeros(psf_size,psf_size);  
	% seek height and width
	seekH   = size(E,1); 
	seekW   = size(E,2);
	% cut out center of the estimated image
	seekE   = E; 
	
	for i=1:psf_size
		for j=1:psf_size
			results(i,j) = eval_sroubek_snr(I( (1:seekH) + i - 1, (1:seekW) + j - 1), seekE);  
		end
	end	
	
	best_snr = max(results(:)); 
	
	clear seekE; 
	clear results; 
end