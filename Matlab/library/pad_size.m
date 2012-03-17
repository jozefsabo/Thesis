function [up down left right] = pad_size(psf_size)

    B_w = psf_size(2); 
    B_h = psf_size(1);

    up    = floor(B_h/2); 
    down  = B_h - up - 1; 
    left  = floor(B_w/2); 
    right = B_w - left - 1; 

end
