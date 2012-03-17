%Lower threshold for value
%X     - value
%bound - upper threshold 

function retval = lowcut(X, bound)
    
if (X < bound) 
   retval = bound;  
else
   retval = X; 
end

end