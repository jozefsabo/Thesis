%Generate Poissonian/gaussian image noise according to Foi et al. (2008)
%a          - parameter value
%b          - parameter value 
%result_img - image with added noise
function result_img = FOI07_GenerateNoise(img, a, b)
   % img        = imnoise(img/a,'poisson'        ); 
   
   img_intensity = (0:1:255)/255;
   img_variance  = abs(a * img_intensity + b);   
   
   result_img    = 	imnoise(img, 'localvar', img_intensity, img_variance); 
end