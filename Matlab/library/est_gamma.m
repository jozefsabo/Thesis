%% Estimate the gamma parameter
%%
function g = est_gamma(images, kernels, sigmas)

    gammas = 1./sigmas; 
	P = length(images); 

	hsize = prod(size(kernels{1})); 
	usize = prod(size(images {1}));
	
	sumU = 0; 

	for i=1:length(images)
        img  = images{i}; 
		sumU = sumU + gammas(i).*sum(sum(img.^2)); 
	end
	
	
	sumH = sum(sum([kernels{:}].^2)); 
	
	g = 2*sqrt( (hsize * sumU) ./ ((P-1).*usize.*sumH).^2 );  
    
    clear img; 
end