function image = unvec(v,y,x);

if nargin == 3
  s = [y x];
else
  s = y;
end
image = reshape(v,s);
