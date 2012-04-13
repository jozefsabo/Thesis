%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Michal Sorel
%%% used by: minh.m 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r = flipc(h)
%FLIPC mirror over center (0,0)  
%
%   function r = flipc(h)
%
r = flipud(fliplr(h));