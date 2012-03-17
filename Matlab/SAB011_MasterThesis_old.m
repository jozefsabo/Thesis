    %%% MAIN TESTING GROUND
%%%%%%%%%%%%%%%%%%%%%%%%
% run the global settings
global_settings; 

% create a test directory and switch to it
test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_MasterThesis'); 
cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.csv'); 

% images to test on
%images   = {'lena512', 'castle512'};
images  = {'grass512'}; 

kernels = {'blur_kernel_7'};
%kernels = {'blur_kernel_1' 'blur_kernel_2' 'blur_kernel_3' 'blur_kernel_4' 'blur_kernel_5' 'blur_kernel_6' 'blur_kernel_7' 'blur_kernel_8'}; 
%methods = {'TICO09_LuminanceFusion' , 'SABO11_MergeExperiment', 'SROU03_ImageFusion'};
methods = {'TICO09_LuminanceFusion' , 'SABO11_MergeExperiment'};

PSFs     = [3    5    7    15   31    63   ];
ISOs     = [200  400  1600 3200 6400  12800];  

%PSFs    = [63     ]; 
%ISOs    = [12800  ];
%STDs    = [1 3 7  ];  

ISO_base = 100;
STD_base = 1; 

% if ISO_MODE is not zero, then ISO simulation is used
% otherwise, gaussian noise of standard deviations given in STDs (/255)
% is used 
ISO_MODE  = 1; 

if ISO_MODE
   mSTR = 'ISO'; 
   SRCs = ISOs;
else
   mSTR = 'STD';
   SRCs = STDs; 
end    
 


for i = 1:size(images,2) 
    
    img_source = im2double(imread([images{i} '.png'])); 
    
    for j = 1:size(kernels, 2)
        
        in_kernel = im2double(imread([kernels{j} '.png']));
        
        
        fprintf(rpt_file, 'Input image,%s,\n', images {i});
        fprintf(rpt_file, 'Input kernel,%s,\n', kernels{j});
        fprintf(rpt_file, ',\n');
        
        % initialize PSF and ISO strings
        iso_str = ''; 
        psf_str = ''; 
        % initialize methods results
        met_res  = methods; 
        met_res{size(methods, 2) + 1} = 'BM3D'; 
        met_res{size(methods, 2) + 2} = 'Blurred image'; 
        met_res{size(methods, 2) + 3} = 'Noisy image'; 
        met_res{size(methods, 2) + 4} = 'Noise standard deviation estimation'; 
        
                for l = 1:size(PSFs(:))
                    % resize kernel for use
                    in_PSF   = imresize(in_kernel, [PSFs(l) NaN], 'lanczos3'); 
                    % normalize the kernel
                    in_PSF   = in_PSF + abs(min(in_PSF(:)));
                    in_PSF   = in_PSF / sum(in_PSF(:)); 
                    
                    % generate blurred image and add noise corresponding to base ISO
                    if ISO_MODE
                        img_blur = OJAL08_CameraNoiseSimulation(conv2_ext(img_source, in_PSF), ISO_base); 
                    else
                        img_blur = imnoise(conv2_ext(img_source, in_PSF), 'gaussian', 0, (STD_base/255)^2);
                    end    
                    
                    % evaluate SNR of blurred image
                    blur_snr = eval_snr(img_source, img_blur); 

                    for m = 1:size(SRCs(:))
                        
                        if ISO_MODE
                            % generate noisy image using ISO simulation
                           img_noise = OJAL08_CameraNoiseSimulation(img_source, SRCs(m));
                        else
                            % generate noisy image using gaussian noise
                           img_noise  = imnoise(img_source, 'gaussian', 0, (SRCs(m) / 255)^2);  
                        end
                        
                        % estimate variance of the noisy image
                        est_var   = MALL07_SWT_NoiseEstimation(img_noise);
                        % evaluate SNR of noisy image
                        noise_snr = eval_snr(img_source, img_noise); 
                        
                        % denoise image using the BM3D algorithm
                        [NA, img_bm3d] = BM3D(1, img_noise, est_var*255);
                        % evaluate SNR of BM3D denoised image
                        bm3d_snr  = eval_snr(img_source, img_bm3d);  
                        
                        imwrite(img_blur   , sprintf('%s_%s_PSF_%02d_%s_%05d_blur.png'   , images{i}, kernels{j}, PSFs(l), mSTR, SRCs(m)), 'png'); 
                         
                         
                        
                        iso_str = sprintf('%s,%d', iso_str, SRCs(m)); 
                        psf_str = sprintf('%s,%d', psf_str, PSFs(l)); 
            
                        for k = 1:size(methods, 2)
                            % create the method from string
                            in_method  = str2func(methods{k});
                            % compute image fusion output
                            img_output = in_method(img_blur, img_noise, PSFs(l)); 
                            % add the result SNR to the output string
                            met_res{k} = sprintf('%s,%6.4f', met_res{k}, eval_snr(img_source, img_output));
                        
                            imwrite(img_output, sprintf('%s_%s_PSF_%02d_%s_%05d_%s.png' , images{i}, kernels{j}, PSFs(l), mSTR, SRCs(m), methods{k}), 'png'); 
                        end
                        
                        met_res{k + 1} = sprintf('%s,%6.4f', met_res{k + 1}, bm3d_snr    ); 
                        met_res{k + 2} = sprintf('%s,%6.4f', met_res{k + 2}, blur_snr    ); 
                        met_res{k + 3} = sprintf('%s,%6.4f', met_res{k + 3}, noise_snr   ); 
                        met_res{k + 4} = sprintf('%s,%2.2f', met_res{k + 4}, est_var*255 ); 
                        
                    end
                end
                
        fprintf(rpt_file, 'Kernel size%s\n', psf_str); 
        fprintf(rpt_file, '%s%s\n', mSTR, iso_str); 
        fprintf(rpt_file, '\n'); 
        
        for n = 1:size(met_res, 2)
            fprintf(rpt_file, '%s\n', met_res{n});
        end
            
        fprintf(rpt_file, ',\n');
        fprintf(rpt_file, ',\n');
        
    end
end



fclose(rpt_file); 
cd(THESIS_PATH); 
