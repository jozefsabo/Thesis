function newH = hConstr(oldH)

%
% newH = hConstr(oldH)
%
% impose constraints on blur mask H
%
% e.g. energy preserving, centrosymmetric, positive
% 
% note: we do not use any above constraints, since the behaviour of the
% algorithm becomes unpredictable

newH = oldH;

% positive condition
%%newH(find(oldH<0)) = 0;

% centrosymmetric condition
%newH = (newH + flipud(fliplr(newH)))/2;

% energy preserving condition
%%newH = newH/sum(newH(:));
