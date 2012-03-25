global_settings; 

lena_001_blur_bg_frag_01 = im2double(imread('001_blur_bg_fragment_01.png')); 
lena_001_blur_bg_frag_02 = im2double(imread('001_blur_bg_fragment_02.png')); 
lena_001_blur_bg_frag_03 = im2double(imread('001_blur_bg_fragment_03.png'));

lena_001_nois_bg_frag_01 = im2double(imread('001_nois_bg_fragment_01.png')); 
lena_001_nois_bg_frag_02 = im2double(imread('001_nois_bg_fragment_02.png')); 
lena_001_nois_bg_frag_03 = im2double(imread('001_nois_bg_fragment_03.png'));

lena_002_blur_bg_frag_01 = im2double(imread('002_blur_bg_fragment_01.png')); 
lena_002_blur_bg_frag_02 = im2double(imread('002_blur_bg_fragment_02.png')); 
lena_002_blur_bg_frag_03 = im2double(imread('002_blur_bg_fragment_03.png'));

lena_002_nois_bg_frag_01 = im2double(imread('002_nois_bg_fragment_01.png')); 
lena_002_nois_bg_frag_02 = im2double(imread('002_nois_bg_fragment_02.png')); 
lena_002_nois_bg_frag_03 = im2double(imread('002_nois_bg_fragment_03.png'));

lena_003_blur_bg_frag_01 = im2double(imread('003_blur_bg_fragment_01.png')); 
lena_003_blur_bg_frag_02 = im2double(imread('003_blur_bg_fragment_02.png')); 
lena_003_blur_bg_frag_03 = im2double(imread('003_blur_bg_fragment_03.png'));

lena_003_nois_bg_frag_01 = im2double(imread('003_nois_bg_fragment_01.png')); 
lena_003_nois_bg_frag_02 = im2double(imread('003_nois_bg_fragment_02.png')); 
lena_003_nois_bg_frag_03 = im2double(imread('003_nois_bg_fragment_03.png'));

lena_001_blur_bg_frag_01_avg = mean(lena_001_blur_bg_frag_01(:)); 
lena_001_blur_bg_frag_01_std = std (lena_001_blur_bg_frag_01(:) - lena_001_blur_bg_frag_01_avg); 
lena_001_nois_bg_frag_01_avg = mean(lena_001_nois_bg_frag_01(:)); 
lena_001_nois_bg_frag_01_std = std (lena_001_nois_bg_frag_01(:) - lena_001_nois_bg_frag_01_avg); 

lena_001_blur_bg_frag_02_avg = mean(lena_001_blur_bg_frag_02(:)); 
lena_001_blur_bg_frag_02_std = std (lena_001_blur_bg_frag_02(:) - lena_001_blur_bg_frag_02_avg); 
lena_001_nois_bg_frag_02_avg = mean(lena_001_nois_bg_frag_02(:)); 
lena_001_nois_bg_frag_02_std = std (lena_001_nois_bg_frag_02(:) - lena_001_nois_bg_frag_02_avg); 

lena_001_blur_bg_frag_03_avg = mean(lena_001_blur_bg_frag_03(:)); 
lena_001_blur_bg_frag_03_std = std (lena_001_blur_bg_frag_03(:) - lena_001_blur_bg_frag_03_avg); 
lena_001_nois_bg_frag_03_avg = mean(lena_001_nois_bg_frag_03(:)); 
lena_001_nois_bg_frag_03_std = std (lena_001_nois_bg_frag_03(:) - lena_001_nois_bg_frag_03_avg);

lena_002_blur_bg_frag_01_avg = mean(lena_002_blur_bg_frag_01(:)); 
lena_002_blur_bg_frag_01_std = std (lena_002_blur_bg_frag_01(:) - lena_002_blur_bg_frag_01_avg); 
lena_002_nois_bg_frag_01_avg = mean(lena_002_nois_bg_frag_01(:)); 
lena_002_nois_bg_frag_01_std = std (lena_002_nois_bg_frag_01(:) - lena_002_nois_bg_frag_01_avg); 

lena_002_blur_bg_frag_02_avg = mean(lena_002_blur_bg_frag_02(:)); 
lena_002_blur_bg_frag_02_std = std (lena_002_blur_bg_frag_02(:) - lena_002_blur_bg_frag_02_avg); 
lena_002_nois_bg_frag_02_avg = mean(lena_002_nois_bg_frag_02(:)); 
lena_002_nois_bg_frag_02_std = std (lena_002_nois_bg_frag_02(:) - lena_002_nois_bg_frag_02_avg); 

lena_002_blur_bg_frag_03_avg = mean(lena_002_blur_bg_frag_03(:)); 
lena_002_blur_bg_frag_03_std = std (lena_002_blur_bg_frag_03(:) - lena_002_blur_bg_frag_03_avg); 
lena_002_nois_bg_frag_03_avg = mean(lena_002_nois_bg_frag_03(:)); 
lena_002_nois_bg_frag_03_std = std (lena_002_nois_bg_frag_03(:) - lena_002_nois_bg_frag_03_avg);

lena_003_blur_bg_frag_01_avg = mean(lena_003_blur_bg_frag_01(:)); 
lena_003_blur_bg_frag_01_std = std (lena_003_blur_bg_frag_01(:) - lena_003_blur_bg_frag_01_avg); 
lena_003_nois_bg_frag_01_avg = mean(lena_003_nois_bg_frag_01(:)); 
lena_003_nois_bg_frag_01_std = std (lena_003_nois_bg_frag_01(:) - lena_003_nois_bg_frag_01_avg); 

lena_003_blur_bg_frag_02_avg = mean(lena_003_blur_bg_frag_02(:)); 
lena_003_blur_bg_frag_02_std = std (lena_003_blur_bg_frag_02(:) - lena_003_blur_bg_frag_02_avg); 
lena_003_nois_bg_frag_02_avg = mean(lena_003_nois_bg_frag_02(:)); 
lena_003_nois_bg_frag_02_std = std (lena_003_nois_bg_frag_02(:) - lena_003_nois_bg_frag_02_avg); 

lena_003_blur_bg_frag_03_avg = mean(lena_003_blur_bg_frag_03(:)); 
lena_003_blur_bg_frag_03_std = std (lena_003_blur_bg_frag_03(:) - lena_003_blur_bg_frag_03_avg); 
lena_003_nois_bg_frag_03_avg = mean(lena_003_nois_bg_frag_03(:)); 
lena_003_nois_bg_frag_03_std = std (lena_003_nois_bg_frag_03(:) - lena_003_nois_bg_frag_03_avg);


lena_001_blur_avg = mean([lena_001_blur_bg_frag_01_avg lena_001_blur_bg_frag_02_avg lena_001_blur_bg_frag_03_avg]);  
lena_002_blur_avg = mean([lena_002_blur_bg_frag_01_avg lena_002_blur_bg_frag_02_avg lena_002_blur_bg_frag_03_avg]);  
lena_003_blur_avg = mean([lena_003_blur_bg_frag_01_avg lena_003_blur_bg_frag_02_avg lena_003_blur_bg_frag_03_avg]);  

lena_001_blur_std = mean([lena_001_blur_bg_frag_01_std lena_001_blur_bg_frag_02_std lena_001_blur_bg_frag_03_std]);
lena_002_blur_std = mean([lena_002_blur_bg_frag_01_std lena_002_blur_bg_frag_02_std lena_002_blur_bg_frag_03_std]);
lena_003_blur_std = mean([lena_003_blur_bg_frag_01_std lena_003_blur_bg_frag_02_std lena_003_blur_bg_frag_03_std]);

lena_001_nois_avg = mean([lena_001_nois_bg_frag_01_avg lena_001_nois_bg_frag_02_avg lena_001_nois_bg_frag_03_avg]);  
lena_002_nois_avg = mean([lena_002_nois_bg_frag_01_avg lena_002_nois_bg_frag_02_avg lena_002_nois_bg_frag_03_avg]);  
lena_003_nois_avg = mean([lena_003_nois_bg_frag_01_avg lena_003_nois_bg_frag_02_avg lena_003_nois_bg_frag_03_avg]);  

lena_001_nois_std = mean([lena_001_nois_bg_frag_01_std lena_001_nois_bg_frag_02_std lena_001_nois_bg_frag_03_std]);
lena_002_nois_std = mean([lena_002_nois_bg_frag_01_std lena_002_nois_bg_frag_02_std lena_002_nois_bg_frag_03_std]);
lena_003_nois_std = mean([lena_003_nois_bg_frag_01_std lena_003_nois_bg_frag_02_std lena_003_nois_bg_frag_03_std]);

clear; 
clc; 
