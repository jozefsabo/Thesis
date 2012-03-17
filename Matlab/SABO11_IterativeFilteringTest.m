% run the global settings
global_settings; 

input_file   = 'lena512_orig'; 
methods      = {'TAI08_NoiseEstimation' 'IMM96_NoiseEstimation' 'MALL07_SWT_NoiseEstimation' 'MALL07_DWT_NoiseEstimation'}; 


test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_IterativeFilteringTest'); 
cd(test_dirname); 

delta = 0.0005; 

im_source = im2double(imread([input_file '.png']));
im_origin = im_source; 

est_sig   = 0; 
prev_sig  = 1; 

while (abs(est_sig - prev_sig) > delta)

    img_sum = zeros(size(im_source)); 
    sig_sum = 0; 
    
    for i = 1:size(methods, 2)
    
        in_method = str2func(methods{i}); 
        est_sig   = in_method(im_source); 
        
        [NA im_filt] = BM3D    (1      , im_source, est_sig*255 ); 
        
        img_sum = img_sum + im_filt; 
        sig_sum = sig_sum + est_sig;
    end

    im_source = img_sum / size(methods, 2); 
    prev_sig  = est_sig; 
    est_sig   = sig_sum / size(methods, 2);
    
    imwrite(im_source, sprintf('%s_filtered_%6.5f.png', input_file, est_sig), 'png'); 
    
end

imwrite(im_source, sprintf('%s_filtered_final.png',input_file), 'png'); 
eval_snr(im_source, im_origin);


%change directory back to global 
cd(THESIS_PATH); 
