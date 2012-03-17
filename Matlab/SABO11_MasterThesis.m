%%% SABO11 Master Thesis 
%%%%%%%%%%%%%%%%%%%%%%%%
% run the global settings
global_settings; 

% create a test directory and switch to it
test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_MasterThesis'); 
cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.csv'); 

% images to test on
images  = {'text256' 'castle256'}; 
%images = {'lena256'}; 
% blur kernels 
kernels = {'blurkernel7' 'blurkernel8' 'line' 'blurkernel10'};
% psf size
PSFs     = [31];
%PSFs    = [3  7]
%PSFs     = [3];
% input noise standard deviations
VARs     = [0.0001 0.001 0.01 0.1];
% input noise
%ISOs     = [200];
ISOs     =  [102400];   


% lambda parameters
%lambdas  = [0.001]; 
%lambdas  = [0.001 0.002 0.005 0.007 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.5 1 2 5 10]; 
%lambdas  = [3.7897872];
%gammas   = [0.001288];

% base std
VAR_base = 0.00001;     
% base ISO
ISO_base = 100; 

% if ISO_MODE is not zero, then ISO simulation is used
% otherwise, gaussian noise of standard deviations given in VARs (/255)
% is used 
ISO_MODE  = 0; 

if ISO_MODE
%%
% ISO MODE
% 
    first_line = 'Image,PSF,PSF size,Base ISO,Input ISO,Lambda,Gamma,Noise VAR est,Blur VAR est,Noisy SNR,Blur SNR,TICO09 SNR,SROU03 SNR,BM3D SNR\n';
    fprintf(rpt_file, first_line); 
    tic; 
    for i = 1:size(images,2) 

        img_source = im2double(imread([images{i} '.png'])); 

        for j = 1:size(kernels, 2)

            in_kernel = im2double(imread([kernels{j} '.png']));

                for l = 1:size(PSFs(:))

                     % resize kernel for use
					 if strcmp(kernels{j},'line')
						in_PSF    = in_kernel(1:PSFs(l),1:PSFs(l)); 
					 else
						in_PSF    = imresize(in_kernel, [PSFs(l) NaN], 'lanczos3'); 
                     end 
                     % normalize the kernel
                     in_PSF    = abs(in_PSF);
                     in_PSF    = in_PSF / sum(in_PSF(:)); 


                     % generate blurred image and add noise corresponding to base ISO
                     hlp_blur  = conv2_ext(img_source, in_PSF); 
                     img_blur  = OJAL08_CameraNoiseSimulation(hlp_blur, ISO_base); 
                     % estimate noise std in the blurred image
                     blur_std_est = std2(hlp_blur - img_blur);  
                     

                     % compute padding sizes 
                     [up down left right] = pad_size([PSFs(l) PSFs(l)]);

                    for m = 1:size(ISOs(:))
                        
                        % generate noisy image using ISO simulation
                        img_noise     = OJAL08_CameraNoiseSimulation(img_source, ISOs(m));
                        % estimate standard deviation of noise
                        noise_std_est = std2(img_source - img_noise); 
                        %[NA, img_bm3d]= BM3D(1, img_noise, 255*noise_std_est);

                        %img_tico09 = TICO09_LuminanceFusion(img_blur, img_noise); 

                        %write noisy and BM3D denoised images
                        imwrite(img_noise , sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_noise.png'  , images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m)), 'png');    
                        imwrite(img_blur  , sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_blur.png'   , images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m)), 'png');
                        %imwrite(img_bm3d  , sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_bm3d.png'   , images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m)), 'png');
                        %imwrite(img_tico09, sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_tico09.png' , images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m)), 'png');


                        % evaluate method sucess
                        %blur_snr   = eval_snr        (img_source, img_blur); 
                        blur_isnr  = eval_sroubek_snr(img_source, img_blur);
                        %blur_pmse  = eval_pmse       (img_source, img_blur);

                        %noise_snr  = eval_snr        (img_source, img_noise); 
                        noise_isnr = eval_sroubek_snr(img_source, img_noise);
                        %noise_pmse = eval_pmse       (img_source, img_noise);

                        %bm3d_snr   = eval_snr        (img_source, img_bm3d); 
                        %bm3d_isnr  = eval_sroubek_snr(img_source, img_bm3d);
                        %bm3d_pmse  = eval_pmse       (img_source, img_bm3d);

                        %tico09_snr = eval_snr        (img_source, img_tico09); 
                        %tico09_isnr= eval_sroubek_snr_shift(img_source, img_tico09,PSFs(l));
                        %tico09_pmse= eval_pmse       (img_source, img_tico09);

                        psf_noise = make_delta(PSFs(l),PSFs(l)); 
                        psf_blur  = minh({img_blur},img_noise,[PSFs(l) PSFs(l)],'constr'); 
                        psf_blur  = psf_blur{1};
                        
                        imwrite(psf_blur / max(psf_blur(:)), sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_srou03_psf00.png', images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m)), 'png');

						
						lambda = est_lambda({img_noise img_blur}, {psf_noise psf_blur}, [noise_std_est^2 blur_std_est^2]); 
                        gamma  = est_gamma ({img_noise img_blur}, {psf_noise psf_blur}, [noise_std_est^2 blur_std_est^2]);

						gammas  = [gamma]; 
						lambdas	= [lambda];
                        
                        for k = 1:size(lambdas, 2)
                            
                            for n = 1:size(gammas,2)
                                tic; 
								[img_srou03, h_res] = blindMCIdeconv({image_pad(img_noise,up,down,left,right) image_pad(img_blur,up,down,left,right)},[],'RudOsh',lambdas(k),1e-1,gammas(n),[noise_std_est^2 blur_std_est^2],[],{psf_noise psf_blur},10);
                                toc;
                                % evaluate sroubek's method success
                                %srou03_snr = eval_snr        (img_source, img_srou03); 
                                srou03_isnr = eval_sroubek_snr(img_source, img_srou03);
                                %srou03_pmse= eval_pmse       (img_source, img_srou03);
                                
                                % estimated kernels
                                out_psf_1 = h_res{1}; 
                                out_psf_2 = h_res{2};

                                out_psf_1 = out_psf_1 / max(out_psf_1(:)); 
                                out_psf_2 = out_psf_2 / max(out_psf_2(:)); 

                                fprintf(rpt_file, sprintf('%s,%s,%02d,%05d,%05d,%f,%f,%10.9f,%10.9f,%6.4f,%6.4f,%6.4f,%6.4f,%6.4f\n', images{i},kernels{j},PSFs(l),ISO_base,ISOs(m),lambdas(k),gammas(n),noise_std_est^2,blur_std_est^2,noise_isnr,blur_isnr,0,srou03_isnr,0 )); 
                            
                                %write estimated kernels and the MCAM image
                                imwrite(out_psf_1 , sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_lambda_%6.4f_gamma_%6.4f_srou03_psf01.png', images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m), lambdas(k), gammas(n)), 'png');
                                imwrite(out_psf_2 , sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_lambda_%6.4f_gamma_%6.4f_srou03_psf02.png', images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m), lambdas(k), gammas(n)), 'png');
                                imwrite(img_srou03, sprintf('%s_%s_PSF_%02d_ISO_%05d_%05d_lambda_%6.4f_gamma_%6.4f_srou03.png'      , images{i}, kernels{j}, PSFs(l), ISO_base, ISOs(m), lambdas(k), gammas(n)), 'png');
                            end
                        end
                    end

                end

        end

    end
    toc; 
 else 
%%
% STANDARD DEVIATION MODE
%  
   first_line = 'Image,PSF,PSF size,Base VAR,Input VAR,Lambda,Gamma,Noise SNR,Blur SNR,TICO09 SNR,SROU03 SNR,BM3D SNR\n';
   fprintf(rpt_file, first_line);  
   tic;  
   for i = 1:size(images,2) 

        img_source = im2double(imread([images{i} '.png'])); 

        for j = 1:size(kernels, 2)

            in_kernel = im2double(imread([kernels{j} '.png']));

                for l = 1:size(PSFs(:))

                     % resize kernel for use
					 if strcmp(kernels{j},'line')
						in_PSF    = in_kernel(1:PSFs(l),1:PSFs(l)); 
					 else
						in_PSF    = imresize(in_kernel, [PSFs(l) NaN], 'lanczos3'); 
                     end 
                     % normalize the kernel
                     in_PSF    = abs(in_PSF);
                     in_PSF    = in_PSF / sum(in_PSF(:)); 

                     % generate blurred image and add noise corresponding to base ISO
                     img_blur = imnoise(conv2_ext(img_source, in_PSF), 'gaussian', 0, VAR_base);

                     % compute padding sizes 
                     [up down left right] = pad_size([PSFs(l) PSFs(l)]);

                    for m = 1:size(VARs(:))
                        
                        % generate noisy image using gaussian noise
                        img_noise     = imnoise(img_source, 'gaussian', 0, VARs(m));
                        % denoise the image using the BM3D algorithm
                        %[NA, img_bm3d]= BM3D(1, img_noise, sqrt(VARs(m))*255);
                        
                        % TICO09 image fusion
                        %img_tico09 = TICO09_LuminanceFusion(img_blur, img_noise); 

                        %write noisy and BM3D denoised images
                        imwrite(img_noise , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_noise.png'  , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m)), 'png');    
                        imwrite(img_blur  , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_blur.png'   , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m)), 'png');
                        %imwrite(img_bm3d  , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_bm3d.png'   , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m)), 'png');
                        %imwrite(img_tico09, sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_tico09.png' , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m)), 'png');

                        % evaluate method sucess
                        %blur_snr   = eval_snr        (img_source, img_blur); 
                        blur_isnr  = eval_sroubek_snr(img_source, img_blur);
                        %blur_pmse  = eval_pmse       (img_source, img_blur);

                        %noise_snr  = eval_snr        (img_source, img_noise); 
                        noise_isnr = eval_sroubek_snr(img_source, img_noise);
                        %noise_pmse = eval_pmse       (img_source, img_noise);

                        %bm3d_snr   = eval_snr        (img_source, img_bm3d); 
                        %bm3d_isnr  = eval_sroubek_snr(img_source, img_bm3d);
                        %bm3d_pmse  = eval_pmse       (img_source, img_bm3d);

                        %tico09_snr = eval_snr        (img_source, img_tico09); 
                        %tico09_isnr= eval_sroubek_snr_shift(img_source, img_tico09,PSFs(l));
                        %tico09_pmse= eval_pmse       (img_source, img_tico09);
                        
                        
                        psf_noise = make_delta(PSFs(l),PSFs(l)); 
                        psf_blur  = minh({img_blur},img_noise,[PSFs(l) PSFs(l)],'constr'); 
                        psf_blur  = psf_blur{1}; 
                        
                        imwrite(psf_blur / max(psf_blur(:)) , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_psf00.png'   , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m)), 'png');
                        
                        lambda = est_lambda({img_noise img_blur}, {psf_noise psf_blur}, [VARs(m) VAR_base]); 
                        gamma  = est_gamma ({img_noise img_blur}, {psf_noise psf_blur}, [VARs(m) VAR_base]); 
                        
                        %parprod = est_parprod({img_noise img_blur}, {psf_noise psf_blur}, [VARs(m) VAR_base]); 
                        
                        gammas  = [gamma];
						lambdas = [lambda];   
                        
                        
                        for k = 1:size(lambdas, 2)
                            for n = 1:size(gammas, 2)
                                %gamma_k = parprod / lambdas(k); 
                                tic; 
                                [img_srou03, h_res] = blindMCIdeconv({image_pad(img_noise,up,down,left,right) image_pad(img_blur,up,down,left,right)},[],'RudOsh',lambdas(k),1e-1,gammas(n),[VARs(m) VAR_base],[],{psf_noise psf_blur},10);
                                toc; 
                                % evaluate sroubek's method success
                                %srou03_snr = eval_snr        (img_source, img_srou03); 
                                srou03_isnr = eval_sroubek_snr(img_source, img_srou03);
                                %srou03_pmse= eval_pmse       (img_source, img_srou03);

                                % estimated kernels
                                out_psf_1 = h_res{1}; 
                                out_psf_2 = h_res{2};

                                out_psf_1 = out_psf_1 / max(out_psf_1(:)); 
                                out_psf_2 = out_psf_2 / max(out_psf_2(:)); 

                                fprintf(rpt_file, sprintf('%s,%s,%02d,%10.9f,%10.9f,%f,%f,%6.4f,%6.4f,%6.4f,%6.4f,%6.4f\n', images{i},kernels{j},PSFs(l),VAR_base,VARs(m),lambdas(k),gammas(n),noise_isnr,blur_isnr,0,srou03_isnr,0)); 


                                %write estimated kernels and the MCAM image
                                imwrite(out_psf_1 , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_lambda_%6.4f_gamma_%6.4f_srou03_psf01.png', images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m), lambdas(k), gammas(n)), 'png');
                                imwrite(out_psf_2 , sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_lambda_%6.4f_gamma_%6.4f_srou03_psf02.png', images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m), lambdas(k), gammas(n)), 'png');
                                imwrite(img_srou03, sprintf('%s_%s_PSF_%02d_VAR_%6.5f_%6.5f_lambda_%6.4f_gamma_%6.4f_srou03.png'      , images{i}, kernels{j}, PSFs(l), VAR_base, VARs(m), lambdas(k), gammas(n)), 'png');
                            end
                        end
                    end
                end
        end
    end
    toc;
end 



fclose(rpt_file); 
cd(THESIS_PATH); 












