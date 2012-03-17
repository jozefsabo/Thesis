%Experimental blur PSF deblurring method
%in_psf  - input PSF
%out_psf - output PSF
function out_psf = deblur_psf(in_psf)

    coef = 4; 

    in_psf = in_psf + abs(min(in_psf(:))); 
    in_psf = in_psf / max(in_psf(:)); 

    levels = log2(max(size(in_psf, 1), size(in_psf,2))); 
    
    psf_clean = in_psf; 
    
    for i=1:levels
        
        blur_matrix  = ones(2^(levels + 1 - i)   + 1);
        psf_blur     = conv2_ext(in_psf, blur_matrix / sum(blur_matrix(:))); 
        psf_blur_std = std(psf_blur(:)); 
        
        psf_clean(psf_clean < coef*psf_blur_std) = 0; 
        
    end    

    out_psf = psf_clean; 
    
end