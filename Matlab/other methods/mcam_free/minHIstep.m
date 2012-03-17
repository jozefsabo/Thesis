function [iterres, E] = minHIstep(Potfce,sigma2,lambda,sigmas,maxiter,defrelres)

% minHstep()
%
% Solving linear problem Ax=b that is (U'U-lambda*R)h = U'g
% using Gaussian elimination method
% or using fmincon to impose the contraint that the int. values 
% of PSFs must lie between 0 and 1. Fmincon is necessary if PSFs 
% are overestimated. 
%

global hsize FL gU
global U H G R

maxiter = 1; %it is not an iterative alg. (left for future use)

gammas = 1./sigmas;

if ~exist('defrelres')
   defrelres = 1e-4;
end
if isempty(defrelres)
   defrelres = 1e-4;
end

%disp('gU construction');
%gU = kron(eye(length(H)),fftconv2matrix(U,size(H{1})));
eye_mat = eye(length(H)); 
for k = 1:length(H)
    eye_mat(k,k) = gammas(k); 
end    
gU = kron(eye_mat,fftconv2matrix(U,size(H{1})));

FUf = fft2(flipud(fliplr(U)));

step = 1;
fprime = inline([Potfce,'(DU,a,b)']);
% size of image H
hsize = size(H{1});
N = prod(hsize);
alpha = lambda;


b = [];
for k = 1:length(H)
  iff=ifft2(FUf.*fft2(G{k},size(FUf,1),size(FUf,2)));
  %b = [b; vec(real(iff(end-hsize(1)+1:end,end-hsize(2)+1:end)))];
   b = [b; gammas(k).*vec(real(iff(end-hsize(1)+1:end,end-hsize(2)+1:end)))];
end

%%%%
for i = 1:maxiter

ggU = gU;
gU = gU+lambda*R;

%% 1st minimizer; Gaussian elimination
%xmin = gU\b;
%iterres(i,:) = {norm(b-gU*xmin)/norm(b)};

% set H{1} to delta matrix
% H{1} = make_delta(size(H{1})); 
%% 2nd minimizer; fmincon with constraints
%zTz = sum(sum([G{:}].^2));
zTz = 0; 
for k=1:length(G)
    zTz = zTz + gammas(k).*sum(sum([G{k}].^2)); 
end    
x0 = vec([H{:}]);
lb = zeros(size(x0));
ub = ones(size(x0));
options = optimset('GradObj','on','Hessian','on');
[xmin,fval,flag,output] = fmincon(@minHcon,x0,[],[],[] ,[] ,lb,ub,[]     ,options, gU,b,zTz);
% from documentation      fmincon(fun     ,x0,A ,b ,Aeq,beq,lb,ub,nonlcon,options) 				

iterres(i,:) = { flag output.iterations};
%%%%%    

for k=1:length(H)
   H{k} = unvec(xmin(N*(k-1)+1:N*k),hsize);
end
% set H{1} to delta matrix again
%H{1} = make_delta(size(H{1})); 


end

if nargout == 0
   iterres
end
if nargout==2
    E = sort(eig(ggU));
    E = E./E(1);
end

clear global FL hsize gU


