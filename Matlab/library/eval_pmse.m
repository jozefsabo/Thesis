% Percentage mean square error
%
% PMSE = eval_pmse(I,E)
% 
% I ... original image
% E ... estimated image of which PMSE we want to calculate
function p = eval_pmse(I, E)
	p = 100 * (sum ([I(:) - E(:)].^2) / sum( [I(:)].^2));    
end