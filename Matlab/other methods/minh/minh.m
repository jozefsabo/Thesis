function [h, res] = minh(z,a,hsize,method)
%MINH optimal mask (array) for image reconstruction
%
%   function [h, res] = minh({z},a,hsize,method)
%   function [h, res] = minh(z,a,hsize,method)
%
%       a       ... "sharp" image
%       z       ... cell array of degraded images
%       sizeh   ... desired size of mask
%       method  ... 'constr','unconstr'
%       h       ... cell array of masks
%       res     ... residuum
%
%       z must correspond to just a 'valid' part of a
%       i.e. size(z) = size(a) - hsize + 1
%       otherwise it takes automatically central part of z
%
% minimizes sum||z{i}-a*h{i}||^2
% by solving linear system a'ah=z'h
%
%Example: h = minh({wb1},wb4,[11 11],'unconstr');
%
%see also Filip Sroubek's minHIstep.m
%
%Michal Sorel (c) 2004, 2005

nmasks = length(z);
if size(z{1}) ~= size(a)-hsize+1
    warning('Invalid sizes, z size is adjusted.'); 
    for i = 1:nmasks
        z{i} = cut(z{i},size(a)-hsize+1);    
    end
end
ga = kron(eye(nmasks),fftconv2matrix(a,hsize));

A = fft2(flipc(a));

b = [];
for k = 1:nmasks
  iff=ifft2(A.*fft2(z{k},size(A,1),size(A,2)));
  b = [b; vec(real(iff(end-hsize(1)+1:end,end-hsize(2)+1:end)))];
end

switch lower(method)
case 'unconstr'     % 1st minimizer unconstrained
    xmin = ga\b;
case 'constr'       % 2nd minimizer with constraints
    zTz = sum(sum([z{:}].^2));
    x0 = vec(ones(hsize));%vec([h{:}]);
    lb = zeros(size(x0));
    ub = ones(size(x0));
    %options = optimset('GradObj','on','Hessian','on','TolFun',0.000000000001);
    options = optimset('GradObj','on','Hessian','on');
    lambda = 0;
    [xmin,fval,flag,output] = fmincon(@minHcon,x0,[],[],[],[],lb,ub,...
                                        [],options,ga,b,zTz,lambda);
    res = {flag output.iterations}; 
case 'constr2'  % spolehlive konverguje jen bez lb,ub podminky
    zTz = sum(sum([z{:}].^2));
    x0 = vec(ones(hsize));%vec([h{:}]);
    lb = zeros(size(x0));
    ub = ones(size(x0));
    Aeq = ones(1,prod(hsize)); %kron(eye(length(h)),ones(1,N));
    beq = 1;        %ones(length(h),1);    
    options = optimset('GradObj','on'); %,'Hessian','on');
    lambda = 0;
    [xmin,fval,flag,output] = fmincon(@minHcon,x0,[],[],Aeq,beq,[],[],...
                                        [],options,ga,b,zTz,lambda);
    res = {flag output.iterations}; 
otherwise
    error('Uknown method');
end

if nargout == 2, res = {norm(b-ga*xmin)/norm(b)}; end

N = prod(hsize);
for k=1:nmasks
   h{k} = unvec(xmin(N*(k-1)+1:N*k),hsize);
end

function M = fftconv2matrix(p,s)
%
%   M = fftconv2matrix(p,[m,n])
%
% returns matrix (M) so that 
% unvec(M*x,m,n) = conv2(flipud(fliplr(p)),conv2(p,x,'valid'),'valid')
%
% note: uses fft, should be faster than conv2matrix for huge p
m = s(1);
n = s(2);
indi = kron(ones(1,n),[m:-1:1]);
indj = kron([n:-1:1], ones(1,m));
mn = m*n;
M = zeros(mn,mn);
Fp = fft2(fliplr(flipud(p)));

for i=1:mn
  iff = ifft2(Fp.*fft2(p(indi(i):end-m+indi(i),...
			 indj(i):end-n+indj(i)),size(p,1),size(p,2)));
  M(i,:) = vec(real(iff(end-m+1:end,end-n+1:end)))'; 
end

function [y,g,H] = minHcon(x,gU,b,zTz,lambda)  
  y = x'*gU*x - 2*x'*b + zTz;
%  xp = 0.9*x+0.1;
%  y = y - lambda*sum(xp.*log(xp));
  if nargout > 1
    g = gU*x - b;
%    g = g - lambda*( log(xp) + 1);
    if nargout > 2
      H = gU;
%      H = gU - diag(lambda./xp);
    end
  end
  