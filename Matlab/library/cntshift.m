function I_c = cntshift(I)

	i_cog = round(cog(I)); 
	i_cnt = round(size(I)/2); 

	I_c   = circshift(I, i_cnt - i_cog); 

end

