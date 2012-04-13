%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Estimate the lambda parameter product according to Šroubek (2003), extended by Sabo (2012) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% images  - initial image estimas
%%% kernels - initial blur PSF estimates 
%%% sigmas  - noise variance estimates 
%%% l       - estimated lambda parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function l = est_lambda(images, kernels, sigmas)

	c      = 4 + 4/sqrt(2);   	
	gammas = 1./sigmas;

	usize  = prod(size(images {1}));

	% "zle"
	%sumH = sum(sum([kernels{:}].^2));

	% dobre 	
	sumH = 0; 

	for i=1:length(kernels)
        krn  = kernels{i};
		sumH = sumH + gammas(i).*sum(sum(krn.^2)); 
	end
	% end (dobre)
	
	sumU = sum(sum([images{:}].^2)); 
	
	l = sqrt( (usize * sumH) ./ ((c.^2).*sumU) );
    clear krn; 
end