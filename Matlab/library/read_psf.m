function kernel = read_psf(path, size)
	% read kernel from image
	kernel = im2double(imread(path));
    % resize kernel	
    kernel = imresize(kernel, size, 'lanczos3'); 
    % shift kernel above 0 (resizing introduces artifacts) 
    kernel = kernel + abs(min(kernel(:)));  
	% normalize kernel to sum up to 1 
	kernel = kernel / sum(kernel(:)); 
end