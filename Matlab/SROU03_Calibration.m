%%% MODIFIED SROUBEK 03 CALIBRATION 
%%%%%%%%%%%%%%%%%%%%%%%%
% run the global settings
global_settings; 

% create a test directory and switch to it
test_dirname = mk_test_dir(OUTPUT_PATH, 'SROU03_Calibration'); 
cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.csv'); 

% images to test on
images  = {'lena128'}; 
% blur kernels 
kernels = {'line_7'};
% psf size
PSFs     = [7      ];
% input variances
%VARs     = [0.00001 0.0001 0.001 0.01 0.1];
VARs     = [0.01];

% lambda parameters
lambdas  = [0.001   0.001  0.01  0.1  1  10 100 1000]; 
%lambdas  = [10]; 

% base variance
VAR_base = 0.00001; 

%experiment number
exp_no   = 1; 


fprintf(rpt_file, 'Experiment number, Image,Kernel,Kernel size,Base variance,Input variance,Lambda,Noisy SNR,Blur SNR,BM3D SNR,SROU03 SNR\n'); 

for i = 1:size(images,2) 
    
    img_source = im2double(imread([images{i} '.png'])); 
    
    for j = 1:size(kernels, 2)
        
        in_kernel = im2double(imread([kernels{j} '.png']));
        
            for l = 1:size(PSFs(:))
                
                 % resize kernel for use
                 in_PSF   = imresize(in_kernel, [PSFs(l) NaN], 'lanczos3'); 
                 % normalize the kernel
                 in_PSF   = in_PSF + abs(min(in_PSF(:)));
                 in_PSF   = in_PSF / sum(in_PSF(:)); 
                 
                 img_blur = imnoise(conv2_ext(img_source, in_PSF), 'gaussian', 0, VAR_base);
                 [up down left right] = pad_size([PSFs(l) PSFs(l)]);
        
                for m = 1:size(VARs(:))
                    
                    img_noise = imnoise(img_source, 'gaussian', 0, VARs(m));
                        
                    for k = 1:size(lambdas, 2)
                        
                        %[srou03_img, h_res] = blindMCIdeconv({image_pad(img_noise,up,down,left,right) image_pad(img_blur,up,down,left,right)},[],'RudOsh',lambdas(k),1e-1,1,[VARs(m) VAR_base],[],[PSFs(l) PSFs(l)],10);
                        [srou03_img, h_res] = blindMCIdeconv({image_pad(img_noise,up,down,left,right) image_pad(img_blur,up,down,left,right)},[],'RudOsh',lambdas(k),1e-1,1,[VARs(m) VARs(m)],[],[PSFs(l) PSFs(l)],10);
    
                        [NA, bm3d_img] = BM3D(1, img_noise, sqrt(VARs(m))*255);
                        
                        % estimated kernels
                        out_psf_1 = h_res{1}; 
                        out_psf_2 = h_res{2};
                        
                        out_psf_1 = out_psf_1 / max(out_psf_1(:)); 
                        out_psf_2 = out_psf_2 / max(out_psf_2(:)); 
                        
                        fprintf(rpt_file, sprintf('%04d,%s.png,%s.png,%02d,%f,%f,%f,%f,%f,%f,%f\n',exp_no, images{i},kernels{j},PSFs(l),VAR_base,VARs(m),lambdas(k), sroubek_snr(img_noise, img_source), sroubek_snr(img_blur, img_source), sroubek_snr(bm3d_img, img_source), sroubek_snr(srou03_img, img_source))); 
                        
                        imwrite(out_psf_1 , sprintf('%04d_result_psf_01.png', exp_no), 'png');
                        imwrite(out_psf_2 , sprintf('%04d_result_psf_02.png', exp_no), 'png');
                        imwrite(img_blur  , sprintf('%04d_blurred.png'      , exp_no), 'png');
                        imwrite(img_noise , sprintf('%04d_noisy.png'        , exp_no), 'png');
                        imwrite(srou03_img, sprintf('%04d_srou03.png'       , exp_no), 'png');
                        imwrite(bm3d_img  , sprintf('%04d_bm3d.png'         , exp_no), 'png');
                        
                        exp_no = exp_no + 1; 
                    end
                       
                end
                    
            end

    end
    
end

fclose(rpt_file); 
cd(THESIS_PATH); 












