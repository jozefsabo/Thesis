global_settings; 

img = im2double(imread('test.png')); 

img_s = cntshift(img); 

figure, imshow(img); 
figure, imshow(img_s); 
