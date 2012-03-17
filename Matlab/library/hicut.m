%Upper threshold for value
%X     - value
%bound - upper threshold 
function retval = hicut(X, bound)
    
if (X > bound) 
   retval = bound;  
else
   retval = X; 
end

end