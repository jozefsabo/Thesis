function hr = findH(R,p,hsize)

% hr = findH(R,p,hsize)
% find blurs ... min eigenvector of R
% R ... matrix
% p ... number of channels
% hsize = [y x] ... size of blurs
%
    
  [V, D] = eig((R));
  pr = size(R,1)/p;
  DD = (diag(D));
  SDD = sort(DD);
  mineig = find(DD == min(DD));
  VN = zeros(pr*p,1);
  i = mineig;
  VN = V(:,i)/sum(V(:,i))*p;
  j = 1;
  for j = 1:p
    hr{j} = unvec(VN(1+(j-1)*pr:j*pr),hsize);
  end
