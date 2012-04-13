%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Shift the input image's center of gravity to the image center %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% I   - input image 
%%% I_c - shifted image 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I_c = cntshift(I)

	i_cog = round(cog(I)); 
	i_cnt = round(size(I)/2); 

	I_c   = circshift(I, i_cnt - i_cog); 

end

