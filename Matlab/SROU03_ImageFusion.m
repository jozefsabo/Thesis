function img_result = SROU03_ImageFusion(img_blur, img_noise, psf_size)
    
    [up down left right] = pad_size(psf_size); 


    img_blur_pad  = image_pad(img_blur , up, down, left, right);
    img_noise_pad = image_pad(img_noise, up, down, left, right);

    %blur_mean  = mean(img_blur(:)); 
    %noise_mean = mean(img_noise(:)); 
    
    %blur_std   = std(img_blur(:)); 
    %noise_std  = std(img_noise(:)); 

    %img_blur  = (img_blur  - mean(img_blur (:)))/sqrt(var(img_blur (:))); 
    %img_noise = (img_noise - mean(img_noise(:)))/sqrt(var(img_noise(:))); 

    [img_result, hr] = blindMCIdeconv({img_blur_pad img_noise_pad img_noise_pad img_noise_pad},[],'RudOsh',1e4     ,1e-1 ,[]       ,[]     ,[],psf_size           ,2);
    
    %                  blindMCIdeconv (g                                                      ,r ,PotFce  ,u_lambda, u_mu, h_lambda, sigmas, u, h, no_iter, origu, origh)

    
    %img_result = mean(img_blur(:)) + img_result * sqrt(var(img_blur (:))); 
    
end