%Display multiple images

function res = putimages(varargin)

argnum = size(varargin, 2);

floor_sqrt_arg = floor(sqrt(argnum)); 
sqrt_arg       = sqrt(argnum); 

if floor_sqrt_arg < sqrt_arg
  grid = floor_sqrt_arg + 1; 
else
  grid = floor_sqrt_arg;   
end    
    

for I = 1:argnum

    currentarg = varargin{I};
    
    dims = ndims(currentarg);
    
    
    if ((dims == 2) && (size(currentarg, 1) == 1 || size(currentarg, 2) == 1))  
        subplot(grid, grid, I), plot(currentarg);
    else 
        subplot(grid, grid, I), imshow(currentarg); 
    end    
end    

res = 0; 

end