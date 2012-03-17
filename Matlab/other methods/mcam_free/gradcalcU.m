%function g = gradcalcU(x)
function g = gradcalcU(x,sigmas)
%
% g=gradcalcU(x)
% calculate part of the gradient
% this function is used in the CG minimization algorithm
%

global usize H L
gammas = 1./sigmas;

g = 0;
X = unvec(x,usize);
for k = 1:length(H)
  %g = g + vec(conv2(conv2(X,H{k},'valid'),flipud(fliplr(H{k})),'full'));
   g = g + gammas(k).*vec(conv2(conv2(X,H{k},'valid'),flipud(fliplr(H{k})),'full'));
end
g = (g + L*x);
