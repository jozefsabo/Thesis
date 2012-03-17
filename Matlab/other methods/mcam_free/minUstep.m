function [iterres, E] = minUstep(Potfce,lambda,mu,sigmas,maxiter,defrelres)

% minUstep()
%
% solving linear problem Ax=b that is (H'H-(1/lambda)*L(v))u = H'g
% using CG iterative method
%
global usize L
global U H G

if ~exist('maxiter') 
   maxiter = 5;
end
if isempty(maxiter)
   maxiter = 5;
end

if ~exist('defrelres')
   defrelres = 1e-4;
end
if isempty(defrelres)
   defrelres = 1e-4;
end

gammas = 1./sigmas; 

gH = H;
step = 1;
fprime = inline([Potfce,'(DU,a)']);
% size of image U
usize = size(U);
N = prod(usize);
beta = mu*pi/8;
%step2lambda = 1/(lambda*step^2);
step2lambda = lambda;

b = 0;
for k=1:length(H)
  %b = b + vec(conv2(G{k},flipud(fliplr(H{k})),'full'));
   b = b + gammas(k).*vec(conv2(G{k},flipud(fliplr(H{k})),'full'));
end

for i = 1:maxiter
%
% min F(u,v) with respect to v (fix u)
%

% for E1 energy function
VV = ((U(2:end,:)-U(1:end-1,:)).^2)/step;
VV = vec([fprime(VV,beta); zeros(1,size(VV,2))]);
%VV = vec([ones(size(VV)); zeros(1,size(VV,2))]);

VH = ((U(:,2:end)-U(:,1:end-1)).^2)/step;
VH = vec(fprime(VH,beta));
%VH = vec(ones(size(VH)));

% for E2 energy function two extra diagonal terms
VVH1 = ((U(2:end,2:end)-U(1:end-1,1:end-1)).^2)/step;
VVH1 = vec([fprime(VVH1,beta/sqrt(2)); zeros(1,size(VVH1,2))])./sqrt(2);
VVH2 = ((U(1:end-1,2:end)-U(2:end,1:end-1)).^2)/step;
VVH2 = [0; vec([fprime(VVH2,beta/sqrt(2)); zeros(1, size(VVH2,2))])]./sqrt(2);

%
% construct sparse matrix L(v)
% for E1 energy function
L = spdiags(VV,-1,N,N) + spdiags(VH,-usize(1),N,N);
% for E2 energy add the following line
L = L + spdiags(VVH1,-usize(1)-1,N,N) + spdiags(VVH2,-usize(1)+1,N,N);
L = L+L';
L = -step2lambda*(L - spdiags(sum(L,2),0,N,N));


% min F(u,v) with respect to u (fix v)
%
%[xmin,flag,relres,iter,resvec] = pcg(@gradcalcU,b,defrelres,100  ,[],[],vec(U));
[xmin,flag,relres,iter,resvec] = pcg(@gradcalcU,b,defrelres,100  ,[],[],vec(U),sigmas);
% from documentation             pcg(A         ,b,tol      ,maxit,M1,M2,x0)								
iterres(i,:) = {flag relres iter resvec};
%relres
%iter
% final solution
U = unvec(xmin,usize);

if flag~=0 | iter==0
   break;
end

end

if nargout==2
  E = unvec(diag(L),usize);
end
if nargout==0
   iterres{:,2}
end
clear global L usize 






