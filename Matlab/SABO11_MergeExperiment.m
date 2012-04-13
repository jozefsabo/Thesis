%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Experimental wavelet merge method, eventually unused in the thesis %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_image = SABO11_MergeExperiment(img_blur, img_noise)

% spatial window size - constant
s_w_siz = 8;

% wavelet window size 
w_w_siz = s_w_siz / 2;  

% wavelet decomposition of the noisy image
[coefs_noise, sizes_noise] = wavedec2(img_noise, wmaxlev([size(img_noise, 1) size(img_noise, 2)], 'bior1.1'), 'bior1.1');

% dimensions of the finest level of wavelet decomposition
w_width   = sizes_noise(size(sizes_noise, 1) - 1, 2); 
w_height  = sizes_noise(size(sizes_noise, 1) - 1, 1); 

% image dimensions
img_width = size(img_noise, 2); 
img_height= size(img_noise, 1);

index_vec  = (1:(w_width * w_height)) - 1; 

max_h = reshape(coefs_noise(end - 3*w_width*w_height + 1 + 3 * index_vec    )  , w_height, w_width);
max_v = reshape(coefs_noise(end - 3*w_width*w_height + 1 + 3 * index_vec + 1)  , w_height, w_width);
max_d = reshape(coefs_noise(end - 3*w_width*w_height + 1 + 3 * index_vec + 2)  , w_height, w_width);

fin_coef = coefs_noise((end - 3 * w_width * w_height + 1):end); 

total_var = (median(abs(fin_coef - median(fin_coef)))./0.6745).^2;

w_coef(:,:,1) = max_h; 
w_coef(:,:,2) = max_v; 
w_coef(:,:,3) = max_d; 

% difference image
img_diff    = img_blur - img_noise; 
img_weights = img_blur; 

for i=1:size(img_blur, 1)
    for j=1:size(img_blur, 2)
        
        % spatial window
        s_w_x1 = max(j - s_w_siz,1); 
        s_w_y1 = max(i - s_w_siz,1);
        s_w_x2 = min(j + s_w_siz - 1, img_width); 
        s_w_y2 = min(i + s_w_siz - 1, img_height); 
    
        % wavelet window
        w_w_x1 = max(floor(i./2) - w_w_siz, 1); 
        w_w_y1 = max(floor(j./2) - w_w_siz ,1);
        w_w_x2 = min(floor(i./2) + w_w_siz - 1,w_width);
        w_w_y2 = min(floor(j./2) + w_w_siz - 1,w_height);
        
        % linearized wavelet coefficients window
        lin_coef = reshape(w_coef(w_w_y1:w_w_y2, w_w_x1:w_w_x2),1,[]); 
        % linearized difference image window
        lin_img  = reshape(img_diff(s_w_y1:s_w_y2, s_w_x1:s_w_x2),1,[]);
        
        % estimate of standard deviation in the current window
        w_var    = (median(abs(lin_coef - median(lin_coef))) ./ 0.6745).^2; 
        % average of squared difference signal in the current window
        avg_diff = mean(lin_img.^2);
        
        % img_weights(i,j) = total_var ./ (max(w_var, avg_diff));
        img_weights(i,j) = w_var ./ (max(w_var, avg_diff));
    
    end
end    

out_image = img_noise + img_weights.*img_diff;

end