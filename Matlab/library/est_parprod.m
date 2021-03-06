%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Estimate parametric (lambda and gamma) product according to �roubek (2003), extended by Sabo (2012) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% images  - initial image estimas
%%% kernels - initial blur PSF estimates 
%%% sigmas  - noise variance estimates 
%%% parprod - estimated parametric product
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function parprod = est_parprod(images, kernels, sigmas)

	P = length(images); 
	c = 4 + 4/sqrt(2);
	
	hsize = prod(size(kernels{1})); 
	usize = prod(size(images {1}));
	
	parprod = (1 ./ (c * (P-1))).*sqrt(P*hsize/usize); 

end