%%% Evaluate peak signal to noise ratio

%Formula taken from "A Novel Architecture for Wavelet based Image Fusion"
%by Susmitha Vekkot and Pancham Shukla in World Academy of Science,
%Engineering and Technology 57 2009
function psnr_result = eval_psnr(image_A, image_B)

    psnr_result = 10 * log10(1 / eval_mse(image_A, image_B));  

end