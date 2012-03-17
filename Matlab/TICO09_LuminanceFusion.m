% psf_size is ignored (for compatibility only) 
function out_image = TICO09_LuminanceFusion(img_blur, img_noise)

size_x = size(img_blur, 2);
size_y = size(img_blur, 1); 

% window half size
w_size     = 3;

% window area 
w_area     = (2 * w_size + 1).^2; 

% window vector
w_vect_x   = -w_size:w_size;  
w_vect_y   = -w_size:w_size; 

swt_levels = wmaxlev(size(img_blur),'haar'); 

[b_A b_H b_V b_D] = swt2(img_blur , swt_levels, 'haar'); 
[n_A n_H n_V n_D] = swt2(img_noise, swt_levels, 'haar'); 

% difference coefficients
d_A = b_A - n_A; 
d_H = b_H - n_H;
d_V = b_V - n_V;
d_D = b_D - n_D; 

% result coefficients
r_A = b_A; 
r_H = b_H; 
r_V = b_V; 
r_D = b_D; 

% first level noise coefficients for noise variance estimation
n_est_H = n_H(:,:,1);
n_est_V = n_V(:,:,1);
n_est_D = n_D(:,:,1);

% initialize variance matrix
var_mtx = zeros([size_y size_x]); 

% pre-compute local noise variances
for j=1:size_x
    for k=1:size_y
        
            w_x_coor = min(max(w_vect_x + j,1), size(img_blur, 2));
            w_y_coor = min(max(w_vect_y + k,1), size(img_blur, 1));

             % estimate noise variance for the given location
            
            n_est_w                             = (1:3*w_area); 
            n_est_w(1              : w_area  )  = reshape(n_est_H(w_y_coor, w_x_coor), 1, []); 
            n_est_w(w_area+1       : 2*w_area ) = reshape(n_est_V(w_y_coor, w_x_coor), 1, []); 
            n_est_w(2*w_area    + 1: 3*w_area ) = reshape(n_est_D(w_y_coor, w_x_coor), 1, []); 
            
            var_mtx(k,j)   = (1.4826 * median(abs(n_est_w - median(n_est_w)))).^2; 
        
    end
end


for i=(1:swt_levels)
    for j=1:size(img_blur, 2)
        for k=1:size(img_blur,1)
            % calculate window coordinates    
            w_x_coor = min(max(w_vect_x + j,1), size(img_blur, 2));
            w_y_coor = min(max(w_vect_y + k,1), size(img_blur, 1));

            % difference coefficients subselection
            d_A_w = d_A(w_y_coor, w_x_coor, i); 
            d_H_w = d_H(w_y_coor, w_x_coor, i);
            d_V_w = d_V(w_y_coor, w_x_coor, i);
            d_D_w = d_D(w_y_coor, w_x_coor, i);
            
            loc_d_A   = d_A(w_y_coor, w_x_coor, i);   
            loc_d_H   = d_H(w_y_coor, w_x_coor, i);   
            loc_d_V   = d_V(w_y_coor, w_x_coor, i);   
            loc_d_D   = d_D(w_y_coor, w_x_coor, i);   
            
            loc_avg_A   = mean(loc_d_A(:).^2); 
            loc_avg_H   = mean(loc_d_H(:).^2); 
            loc_avg_V   = mean(loc_d_V(:).^2); 
            loc_avg_D   = mean(loc_d_D(:).^2); 
            
            loc_var     = var_mtx(k,j); 
            
            k_A         = loc_var / max(loc_var, loc_avg_A); 
            k_H         = loc_var / max(loc_var, loc_avg_H); 
            k_V         = loc_var / max(loc_var, loc_avg_V); 
            k_D         = loc_var / max(loc_var, loc_avg_D); 
        
            % calculate result values 
            r_A(k,j,i) = n_A(k, j, i) + k_A.*d_A(k,j,i);
            r_H(k,j,i) = n_H(k, j, i) + k_H.*d_H(k,j,i);
            r_V(k,j,i) = n_V(k, j, i) + k_V.*d_V(k,j,i);
            r_D(k,j,i) = n_D(k, j, i) + k_D.*d_D(k,j,i);
            
        end
        
    end
end



out_image = iswt2(r_A, r_H, r_V, r_D, 'haar'); 

end