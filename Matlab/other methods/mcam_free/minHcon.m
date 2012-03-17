function [y,g,H] = minHcon(x,gU,b,zTz)

  y = x'*gU*x - 2*x'*b + zTz;
  if nargout > 1
    g = gU*x - b;
    if nargout > 2
      H = gU;
    end
  end
  