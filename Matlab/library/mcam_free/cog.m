function c = cog(F)
  
  % Return center of gravity of image F
  % modification by Jozef Sabo, 2012
  c= [1, 1] + [[0:size(F,1)-1]*sum(F,2), sum(F,1)*[0:size(F,2)-1]']/sum(F(:));
  
end  

  