%%% Real experiment data processing.
%%%
global_settings; 

% create a test directory and switch to it
test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_MasterThesis_RealData lena003'); 
cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.txt'); 

images   = {'lena003' }; %'lena226' 'lena238'}; 
imrefs   = {'lena256' }; %'lena256' 'lena256'};

% master reference image

PSFs     = [17]; 
 

for i=1:length(images)
    
    % original image
    im_orig = im2double(imread([images{i} '.png' ]));
    % reference image
    im_ref  = im2double(imread([imrefs{i} '.png' ])); 
    
    %determine the PSF size
    %PSFsize = size(im_ref,1) - size(im_orig,1) + 1;  
    PSFsize = PSFs(i); 
    
    im_blur = im2double(imread([images{i} '_blur.png' ]));
    im_noise= im2double(imread([images{i} '_noise.png']));

    % 'equalize' images
    im_blur  = REIN01_StatsTransfer(im_orig, im_blur ); 
    im_noise = REIN01_StatsTransfer(im_orig, im_noise); 

    % write equalized images to files
    imwrite(im_blur  , [images{i} '_blur_eq.png'  ], 'png');
    imwrite(im_noise , [images{i} '_noise_eq.png' ], 'png');


    fprintf(rpt_file, 'File processed: %s\n',[images{i} '.png']); 
    

    % estimate noise standard deviations on equalized files
    blur_stds  = [IMM96_NoiseEstimation(im_blur)  TAI08_NoiseEstimation(im_blur) ];% MALL07_DWT_NoiseEstimation(im_blur)  MALL07_SWT_NoiseEstimation(im_blur )]; 
    noise_stds = [IMM96_NoiseEstimation(im_noise) TAI08_NoiseEstimation(im_noise)];% MALL07_DWT_NoiseEstimation(im_noise) MALL07_SWT_NoiseEstimation(im_noise)]; 

    fprintf(rpt_file, 'Estimated noise standard deviations for the blurred image: %8.7f, %8.7f, %8.7f, %8.7f \n',blur_stds ); 
    fprintf(rpt_file, 'Estimated noise standard deviations for the noisy   image: %8.7f, %8.7f, %8.7f, %8.7f \n',noise_stds); 
    
    blur_std   = mean(blur_stds ); 
    noise_std  = mean(noise_stds);
    
    fprintf(rpt_file, 'Average noise standard deviation for the blurred image: %8.7f \n',blur_std ); 
    fprintf(rpt_file, 'Average noise standard deviation for the noisy   image: %8.7f \n',noise_std); 
    

    % remove noise using the BM3D algorithm
    %[NA, bm3d] = BM3D(1, im_noise, 255*noise_std);
    % write BM3D image
    %imwrite(bm3d  ,[images{i} '_bm3d.png'  ],'png');

    % compute padding sizes
%     [up down left right] = pad_size([PSFsize PSFsize]); 
%     % TICO09 wavelet fusion
%     tic;
%     tico09     = TICO09_LuminanceFusion(image_pad(im_blur, up, down, left, right), image_pad(im_noise,up,down,left,right));
%     toc;
%     % cut out the center of the image again
%     tico09     = tico09( (1:size(im_orig,1)) + up, (1:size(im_orig,2)) + up); 
%     % write TICO09 image
%     imwrite(tico09,[images{i} '_tico09.png'],'png');


    fprintf(rpt_file, 'Noise  SNR: %6.4f\n',eval_sroubek_snr_scan(im_ref, im_noise));
    fprintf(rpt_file, 'Blur   SNR: %6.4f\n',eval_sroubek_snr_scan(im_ref, im_blur ));
    %fprintf(rpt_file, 'TICO09 SNR: %6.4f\n',eval_sroubek_snr_scan(im_ref, tico09));
    %fprintf(rpt_file, 'BM3D   SNR: %6.4f\n',eval_sroubek_snr_scan(im_ref, bm3d));
    
    % delta function as parameter
    psf_noise = make_delta(PSFsize,PSFsize);

    psf_blur  = minh({im_blur},im_noise,[PSFsize PSFsize],'constr'); 
    psf_blur  = psf_blur{1};

    % shift psf blur towards the center
    psf_blur  = cntshift(psf_blur); 
    

    % estimation of gamma and lambda parameters
    lambda     = est_lambda({im_noise im_blur}, {psf_noise psf_blur}, [noise_std^2 blur_std^2]); 
    gamma      = est_gamma ({im_noise im_blur}, {psf_noise psf_blur}, [noise_std^2 blur_std^2]);

    
    lambdas    = [10]; 
    gammas     = [0.01]; 
        
    
    for j=1:size(gammas,2)
        for k=1:size(lambdas,2)
    
            % SROU03 MCAM
            tic; 
            [srou03, h_res] = blindMCIdeconv({im_noise im_blur},[],'RudOsh',lambdas(k),1e-1,gammas(j),[noise_std^2 blur_std^2],[],[PSFsize PSFsize],10);
            toc;

            % resulting kernels
            srou03_psf01 = h_res{1}; 
            srou03_psf01 = srou03_psf01 / max(srou03_psf01(:));  

            srou03_psf02 = h_res{2}; 
            srou03_psf02 = srou03_psf02 / max(srou03_psf02(:));  
            psf_blur     = psf_blur / max(psf_blur(:)); 


            % SROU03 output
            imwrite(srou03      ,[images{i} sprintf('_%6.4f_%6.4f_srou03.png'      ,lambdas(k),gammas(j))],'png');
            % kernels output
            imwrite(srou03_psf01,[images{i} sprintf('_%6.4f_%6.4f_srou03_psf01.png',lambdas(k),gammas(j))],'png');
            imwrite(srou03_psf02,[images{i} sprintf('_%6.4f_%6.4f_srou03_psf02.png',lambdas(k),gammas(j))],'png');
            imwrite(psf_blur    ,[images{i} sprintf('_%6.4f_%6.4f_srou03_psf00.png',lambdas(k),gammas(j))],'png');
    
            fprintf(rpt_file, 'SROU03 SNR for lambda %6.4f and gamma %6.4f: %6.4f \n',lambdas(k),gammas(j), eval_sroubek_snr_scan(im_ref, srou03));
        end
    end


    fprintf(rpt_file, '\n\n'); 
    
end

fclose(rpt_file); 
cd(THESIS_PATH); 







