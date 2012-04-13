%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Threshold value from below %%%
%%% X      - value
%%% bound  - lower threshold 
%%% retval - return value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function retval = lowcut(X, bound)
    
	if (X < bound) 
	   retval = bound;  
	else
	   retval = X; 
	end

end