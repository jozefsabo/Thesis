function R = R2matrix(g, hsize, sigmas)

%
% R = R2matrix(g, hsize)
%
% Create R matrix for the partial-data case according to
% Harikuma-Bresler's article
%
% g ... blurred images (cell array)
% hsize ... size of blurs [y,x]
%
% modified by Jozef Sabo, 2012

global G

if ~isempty(g)
   G = g;
   clear g;
end

N = prod(hsize);

% matrix Y'*Y construction
tic;
disp('R construction');
R = zeros(N*length(G));
for i = 1:length(G)
   r = localr2matrix(i,i,hsize);
   for k = [1:i-1, i+1:length(G)]
     % modification by Jozef Sabo, 2012 
     R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) = R(N*(k-1)+1:N*k,N*(k-1)+1:N*k) + (1./(sigmas(i) + sigmas(k))).*r;
   end
   for j = i+1:length(G)
	 % modification by Jozef Sabo, 2012
      r = -(1./(sigmas(i) + sigmas(j))).*localr2matrix(i,j,hsize);
      R(N*(i-1)+1:N*i,N*(j-1)+1:N*j) = r; 
      R(N*(j-1)+1:N*j,N*(i-1)+1:N*i) = r.';
   end
end
toc




function M = localr2matrix(p,q,s)

global G

m = s(1);
n = s(2);
indi = kron(ones(1,n),[m:-1:1]);
indj = kron([n:-1:1], ones(1,m));
mn = m*n;
M = zeros(mn,mn);
if p==q
   for i=1:mn
      for j=i:mn
         M(i,j) = sum(sum( G{p}(indi(i):end-m+indi(i),indj(i):end-n+indj(i)).*G{p}(indi(j):end-m+indi(j),indj(j):end-n+indj(j)) ));
         M(j,i) = M(i,j);
      end
   end
else
   for i=1:mn
      for j=1:mn
         M(i,j) = sum(sum( G{q}(indi(i):end-m+indi(i),indj(i):end-n+indj(i)).*G{p}(indi(j):end-m+indi(j),indj(j):end-n+indj(j)) ));
     end
   end
end
