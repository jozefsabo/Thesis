%make the elements of x greater than or equal to zero and sum up to 1
%works for real values only
function y = normshift(x)

    x_siz = size(x); 

    x = reshape(x,1,[]); 
    x = x + abs(min(x(:))); 
    x = x / sum(x(:)); 
    
    y = reshape(x,x_siz); 

end