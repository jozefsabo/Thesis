%Evaluate mean squared error between two images.
%Images are considered equal in both dimensions.

%Formula taken from "A Novel Architecture for Wavelet based Image Fusion"
%by Susmitha Vekkot and Pancham Shukla in World Academy of Science,
%Engineering and Technology 57 2009
function mse_val = eval_mse(image_A, image_B)

image_diff = image_A - image_B
image_diff = image_diff.^2; 

mse_val    = sum(image_diff) / (size(image_A,1)*size(image_A,2));   

end 