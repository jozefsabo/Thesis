%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Re-formatting of Wiener kernel - equivalent of fftshift %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% wiener_kernel - input kernel
%%% kernel_size   - kernel size
%%% real_kernel   - re-formatted kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function real_kernel = reformat_wiener_kernel(wiener_kernel, kernel_size)

	true_kernel = zeros(kernel_size, kernel_size); 

	from_left  = floor(kernel_size / 2) ;  
	from_right = kernel_size - from_left; 

	carry      = 0; 

	if (from_right == from_left)
		carry  = 1; 
	end    


	true_kernel(carry + from_right : kernel_size, carry + from_right : kernel_size) = wiener_kernel(1                    :from_right, 1                    :from_right );   
	true_kernel(carry + from_right : kernel_size, 1                  : from_left  ) = wiener_kernel(1                    :from_right, (end - from_left + 1):end        ); 

	true_kernel(1                  : from_left  , 1                  : from_left  ) = wiener_kernel((end - from_left + 1):end       , (end - from_left + 1):end        );
	true_kernel(1                  : from_left  , carry + from_right : kernel_size) = wiener_kernel((end - from_left + 1):end       , 1                    :from_right );


	real_kernel = true_kernel; 

end