%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Threshold value from above %%%
%%% X      - value
%%% bound  - upper threshold 
%%% retval - return value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function retval = hicut(X, bound)
    
	if (X > bound) 
	   retval = bound;  
	else
	   retval = X; 
	end

end