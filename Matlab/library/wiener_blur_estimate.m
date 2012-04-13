%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Blur PSF estimate using a Wiener filter %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% blur_img  - blurred and noisy image
%%% noisy_img - noisy image
%%% k1        - ratio
%%% psf_size  - PSF size         
%%% b_k       - estimated blur PSF 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b_k = wiener_blur_estimate(blur_img, noisy_img, k1, psf_size)

    %FFT of blurred image
    R  = fft2(blur_img);
    %FFT of noisy image 
    S  = fft2(noisy_img); 
    %complex conjugate of S
    Sc = conj(S); 
    %FFT of blur kernel 
    K  = ((R.*Sc) ./ (S.*Sc + k1)); 
    %shift to the center
    b_k  = fftshift(ifft2(K));
    %cut out the central psf_size-d region
    b_k = b_k( (1:psf_size) + floor( size(b_k, 1) / 2) - floor(psf_size/2), (1:psf_size) + floor( size(b_k, 2) / 2) - floor(psf_size/2))  ; 
    %make all b_k elements greater or equal to zero
    b_k = normshift(b_k);
end


