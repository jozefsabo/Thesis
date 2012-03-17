function c = cog(F)
  
  % Return center of gravity of image F
  
  c= [1, 1] + [[0:size(F,1)-1]*sum(F,2), sum(F,1)*[0:size(F,2)-1]']/sum(F(:));
  
  
end  

  