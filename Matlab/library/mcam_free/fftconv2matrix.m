function M = fftconv2matrix(p,s)

%
% M = fftconv2matrix(p,[m,n])
% returns matrix (M) so that 
%				unvec(M*x,m,n) = conv2(flipud(fliplr(p)),conv2(p,x,'valid'),'valid')
%
% note: uses fft, should be faster than conv2matrix for large p
%

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
