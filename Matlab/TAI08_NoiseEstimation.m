function est_sig = TAI08_NoiseEstimation(img_noise)
% image dimensions
[h w]   = size(img_noise);
% percentage of highest value pixels (in Sobel edge detection image)
% to exclude from calculations
p     = 0.1; 
% Sobel operators
sob_x = [-1 -2 -1;  0  0  0;  1  2  1];   
sob_y = [-1  0  1; -2  0  2; -1  0  1];             
% Laplacian
lap   = [1  -2  1; -2  4 -2;  1 -2  1];  

% detect edges using the Sobel operator
Gx    = conv2_ext(img_noise, sob_x); 
Gy    = conv2_ext(img_noise, sob_y); 
G     = abs(Gx) + abs(Gy); 
G     = G / max(G(:)); 

% smooth the image using the Laplacian
G_lap = abs(conv2_ext(img_noise, lap)); 

% compute image histogram
[nums, vals] = imhist(G); 

tot_pix = h*w;
i       = 256; 
sum_pix = nums(i); 

num_pix = p*tot_pix; 

% determine threshold
while (sum_pix <= num_pix)
    i       = i - 1; 
    sum_pix = sum_pix + nums(i);  
end    

thr = vals(i); 

G_lap(G >= thr) = 0; 

est_sig = sqrt(pi/2)*sum(G_lap(:)) ./ (6 * (w - 2) * (h - 2)); 

end