%Testing ground for the Tico's method (2006)

clear;
clc; 

global f g1 g2 N sig lambda alpha iter_no iter_thr lambda_hival psf_size;

%variance of the noisy image
sig1     = 0.005; 
%variance of the blurred and less noisy image
sig2     = 0.0001; 
%PSF size
psf_size = 32; 
%sigma^2(d) = sig1^2 + sig2^2 
sig      = sig1 + sig2; 
%influence of the prior p.d.f.
lambda   = 0; 
%step size in the manual gradient descent algorithm
step     = 0.001; 
%global iteration counter
iter_no  = 1;  
%number of iterations after which lambda is set to a high value
iter_thr = 10; 
%lambda - the high value
lambda_hival = 1000; 

%generate simple test data
[f g0 g2 g1 k] = prepare_test_data_simple('lena2.png', 'blur_kernel_1.png', sig1, sig2, psf_size); 

%normalize images
%g1            = g1 / sqrt(var(g1(:))); 
%g2            = g2 / sqrt(var(g2(:))); 

%initial alpha - the ratio of the means 
alpha         = mean(g2(:)) / mean(g1(:)); 
%estimate the psf 
d             = wiener_blur_estimate(g2, g1, 1/sig, psf_size);
%image size in pixels
N             = max(prod(size(g1)), prod(size(g2)));    

%fmincon optimization
options = optimset('GradObj', 'on','Display','iter'); 

%
d             = reshape(d',1,[]); 

%ohraniceni
lb          = zeros(1, psf_size^2); 
ub          = ones(1, psf_size^2); 


[xmin,fval,flag,output] = fmincon(@TICO06_ObjFunc, d, [],[],[],[],lb, ub, [],options);


% MANUAL GRADIENT DESCENT
% for i=1:100
%    
%     [objf_val gr_val] = TICO07_PotFunc(d); 
%     
%     d = d - gr_val*step; 
%     
%     d = normshift(d); 
%     
%     fprintf(1, 'Objective function value: %f', objf_val); 
% end


%r_img = deconvlucy(g2, d); 

%putimages(f, d/max(d(:)), g1, g2, r_img);
