function A = conv2mult(a, b)
%kernel width and height

a_w = size(a,2); 
a_h = size(a,1);

b_w = size(b,2); 
b_h = size(b,1);

b_u = floor(b_h/2); 
b_d = b_h - b_u - 1; 
b_l = floor(b_w/2); 
b_r = b_w - b_l - 1;

a_ext = image_pad(a, b_u, b_d, b_l, b_r); 

A = zeros(size(a,1)*size(a,2), size(b,1)*size(b,2)); 

for i=1:a_w
   for j=1:a_h  
       a_sel                       = a_ext((1:b_h) + j - 1, (1:b_w) + i - 1);
       a_sel                       = reshape(a_sel', 1, []); 
       
       A( (j - 1)*a_w + i , 1:end) = a_sel;   
   end
end

end