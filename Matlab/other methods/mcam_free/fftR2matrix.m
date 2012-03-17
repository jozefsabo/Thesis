function R = fftR2matrix(g, hsize, sigmas)

%
% R = fftR2matrix(g, hsize)
%
% Create R matrix for the partial-data case according to
% Harikuma-Bresler article using FFT, faster for large hsize than
% R2matrix m-file 
%
% g ... blurred images (cell array)
% hsize ... size of blurs [y,x]
%

global G
global FG

if ~isempty(g)
   G = g;
   clear g;
end

for i= 1:length(G);
  FG{i} = fft2(fliplr(flipud(G{i})));
end

N = prod(hsize);

% matrix Y'*Y construction
tic;
disp('R construction');
R = zeros(N*length(G));
for i = 1:length(G)
%  i
  %
  r = localr2matrix(i,i,hsize);
  for k = [1:i-1, i+1:length(G)]
   %R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) = R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) + r; 
    R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) = R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) + (1./(sigmas(i) + sigmas(k))).*r;
  end
  for j = i+1:length(G)
%    j
   %r = -localr2matrix(i,j,hsize);
	r = -(1./(sigmas(i) + sigmas(j))).*localr2matrix(i,j,hsize);
    R(N*(i-1)+1:N*i,N*(j-1)+1:N*j) = r; 
    R(N*(j-1)+1:N*j,N*(i-1)+1:N*i) = r.';
  end
end
toc

clear global FG



function M = localr2matrix(p,q,s)

global G FG

m = s(1);
n = s(2);
indi = kron(ones(1,n),[m:-1:1]);
indj = kron([n:-1:1], ones(1,m));
mn = m*n;
M = zeros(mn,mn);

for i=1:mn
  iff = ifft2(FG{p}.*fft2(G{q}(indi(i):end-m+indi(i),...
	indj(i):end-n+indj(i)),size(G{q},1),size(G{q},2)));
  M(i,:) = vec(real(iff(end-m+1:end,end-n+1:end)))'; 
end

