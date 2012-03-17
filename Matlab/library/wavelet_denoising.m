%Experimental wavelet denoising 
%in_img       - input image
%wavelet_type - wavelet type string
%no_lvl       - number of levels to perform wavelet decomposition
%out_img      - output image 

function out_img = wavelet_denoising(in_img, wavelet_type,no_lvl)

    THR    = 4.5;
    
    [noise_c, noise_s] = wavedec2(in_img  ,wmaxlev( max(size(in_img,1), size(in_img  ,2)), wavelet_type),wavelet_type);

    lo_lvl = 2;
    hi_lvl = size(noise_s,1) - 1; 

    noise_s_sq = noise_s.*noise_s; 
    

    for i = (hi_lvl - no_lvl + 1):hi_lvl
        
        lvl_size     = noise_s_sq(i); 
        off_set      = noise_s_sq(1) + 3*sum(noise_s_sq(2:(i-1)));
     
%         lvl_C_vec    = off_set + (1:3*lvl_size); 
%         
%         
%         lvl_C        = noise_c(lvl_C_vec); 
%         
%         lvl_C_std    = abs(std(lvl_C)); 
%         lvl_C(abs(lvl_C) < THR*lvl_C_std) = 0; 
%         
%         noise_c(lvl_C_vec) = lvl_C;       
%         
        
        
        lvl_size_vec = 3*(0:lvl_size-1);  
        
        coefs_H_vec  = lvl_size_vec + 1 + off_set; 
        coefs_V_vec  = coefs_H_vec  + 1;
        coefs_D_vec  = coefs_V_vec  + 1;
        
        coefs_H      = noise_c(coefs_H_vec); 
        coefs_V      = noise_c(coefs_V_vec);
        coefs_D      = noise_c(coefs_D_vec);
        
        std_C_H      = abs(std(coefs_H));       
        std_C_V      = abs(std(coefs_V));
        std_C_D      = abs(std(coefs_D));
        
        coefs_H(abs(coefs_H) <= THR*std_C_H) = 0; 
        coefs_V(abs(coefs_V) <= THR*std_C_V) = 0; 
        coefs_D(abs(coefs_D) <= THR*std_C_D) = 0; 
        
        noise_c(coefs_H_vec) = coefs_H; 
        noise_c(coefs_V_vec) = coefs_V;
        noise_c(coefs_D_vec) = coefs_D;
        
    

    end  
    
    out_img = waverec2(noise_c, noise_s, wavelet_type); 

end