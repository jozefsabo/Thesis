%%% Real experiment data processing.
%%%
global_settings; 

% input and reference images
images   = {'lena001'}; 

% point spread function sizes
PSFs     = [35]; 

% number of SROU03 iterations
no_iter  = 1; 

% specify which methods to run (0 - do not run, otherwise run)
run_bm3d   = 1; 
run_tico09 = 1; 
run_srou03 = 1; 

% equalize images?
run_imeq   = 0; 

% create a test directory and switch to it
%test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_MasterThesis_RealData BM3D, TICO09 lena001 lena002 lena003'); 
test_dirname = mk_test_dir(OUTPUT_PATH, sprintf('%s IMG %s PSF %d ITER %d',mfilename,images{:},PSFs(:),no_iter)); 

cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.txt'); 


for i=1:length(images)

    % original / reference image
    im_orig = im2double(imread([images{i} '.png' ]));
    
    % determine the PSF size
    PSFsize = PSFs(i); 
    % read blurred and noisy images
    im_blur = im2double(imread([images{i} '_blur.png' ]));
    im_noise= im2double(imread([images{i} '_noise.png']));

    % 'equalize' images
    if run_imeq
        im_blur  = REIN01_StatsTransfer(im_orig, im_blur ); 
        im_noise = REIN01_StatsTransfer(im_orig, im_noise); 
    end
    
    % write equalized images to files
    imwrite(im_blur , [images{i} '_blur_eq.png'  ], 'png');
    imwrite(im_noise, [images{i} '_noise_eq.png' ], 'png');

    fprintf(rpt_file, 'File processed: %s\n\n',[images{i} '.png']); 

    % compute means and stds of images 
	orig_mean  = mean(im_orig (:));
	blur_mean  = mean(im_blur (:));
	noise_mean = mean(im_noise(:));
	
	orig_std   = std(im_orig (:));
	blur_std   = std(im_blur (:));
	noise_std  = std(im_noise(:));

	fprintf(rpt_file, 'Mean and standard deviation for the original image        : %8.7f, %8.7f \n'              ,orig_mean , orig_std);
	fprintf(rpt_file, 'Mean and standard deviation for the blurred  image        : %8.7f, %8.7f \n'              ,blur_mean , blur_std);
	fprintf(rpt_file, 'Mean and standard deviation for the noisy    image        : %8.7f, %8.7f \n\n'            ,noise_mean, noise_std);
	
    % estimate noise standard deviations on equalized files
    orig_n_stds  = [IMM96_NoiseEstimation(im_orig)  TAI08_NoiseEstimation(im_orig)  MALL07_DWT_NoiseEstimation(im_orig)  MALL07_SWT_NoiseEstimation(im_orig )]; 
    blur_n_stds  = [IMM96_NoiseEstimation(im_blur)  TAI08_NoiseEstimation(im_blur)  MALL07_DWT_NoiseEstimation(im_blur)  MALL07_SWT_NoiseEstimation(im_blur )]; 
    noise_n_stds = [IMM96_NoiseEstimation(im_noise) TAI08_NoiseEstimation(im_noise) MALL07_DWT_NoiseEstimation(im_noise) MALL07_SWT_NoiseEstimation(im_noise)]; 

    fprintf(rpt_file, 'Estimated noise standard deviations for the original image: %8.7f, %8.7f, %8.7f, %8.7f \n'  ,orig_n_stds ); 
    fprintf(rpt_file, 'Estimated noise standard deviations for the blurred  image: %8.7f, %8.7f, %8.7f, %8.7f \n'  ,blur_n_stds ); 
    fprintf(rpt_file, 'Estimated noise standard deviations for the noisy    image: %8.7f, %8.7f, %8.7f, %8.7f \n\n',noise_n_stds); 
    
    orig_n_std   = mean(orig_n_stds ); 
    blur_n_std   = mean(blur_n_stds ); 
    noise_n_std  = mean(noise_n_stds);
    
    fprintf(rpt_file, 'Average noise standard deviation for the original image   : %8.7f \n'  ,orig_n_std ); 
    fprintf(rpt_file, 'Average noise standard deviation for the blurred  image   : %8.7f \n'  ,blur_n_std ); 
    fprintf(rpt_file, 'Average noise standard deviation for the noisy    image   : %8.7f \n\n',noise_n_std); 
    
    fprintf(rpt_file, 'Original SNR: none \n'                                           );
    fprintf(rpt_file, 'Noise    SNR: %6.4f\n'  ,eval_sroubek_snr_scan(im_orig, im_noise));
    fprintf(rpt_file, 'Blur     SNR: %6.4f\n\n',eval_sroubek_snr_scan(im_orig, im_blur ));

    % run the BM3D denoising algorithm
    if run_bm3d
        tic;
        [NA, bm3d] = BM3D(1, im_noise, 255*noise_n_std);
        toc; 
    
        % evaluate bm3d statistics 
        bm3d_mean   = mean(bm3d(:));
		bm3d_std    = std (bm3d(:));
		bm3d_n_stds = [IMM96_NoiseEstimation(bm3d) TAI08_NoiseEstimation(bm3d) MALL07_DWT_NoiseEstimation(bm3d) MALL07_SWT_NoiseEstimation(bm3d)]; 
		bm3d_n_std  = mean(bm3d_n_stds); 
		
		fprintf(rpt_file, 'Mean and standard deviation for the bm3d image        : %8.7f, %8.7f \n'              ,bm3d_mean  , bm3d_std); 
        fprintf(rpt_file, 'Estimated noise standard deviations for the bm3d image: %8.7f, %8.7f, %8.7f, %8.7f \n',bm3d_n_stds          ); 
		fprintf(rpt_file, 'Average noise standard deviation for the bm3d image   : %8.7f \n'                     ,bm3d_n_std           ); 
   	
        % evalute BM3D SNR
        fprintf(rpt_file, 'BM3D   SNR: %6.4f\n\n',eval_sroubek_snr_scan(im_orig, bm3d));
        % write BM3D image
        imwrite(bm3d  ,[images{i} '_bm3d.png'  ],'png');
    end
    
    % run TICO09 wavelet fusion algorithm
    if run_tico09

        tic;
        tico09     = TICO09_LuminanceFusion(im_blur, im_noise);
        toc;
		
        % evaluate bm3d statistics 
        tico09_mean   = mean(tico09(:));
		tico09_std    = std (tico09(:));
		tico09_n_stds = [IMM96_NoiseEstimation(tico09) TAI08_NoiseEstimation(tico09) MALL07_DWT_NoiseEstimation(tico09) MALL07_SWT_NoiseEstimation(tico09)]; 
		tico09_n_std  = mean(tico09_n_stds); 
		
		fprintf(rpt_file, 'Mean and standard deviation for the tico09 image        : %8.7f, %8.7f \n'              ,tico09_mean  , tico09_std); 
        fprintf(rpt_file, 'Estimated noise standard deviations for the tico09 image: %8.7f, %8.7f, %8.7f, %8.7f \n',tico09_n_stds            ); 
		fprintf(rpt_file, 'Average noise standard deviation for the tico09 image   : %8.7f \n'                     ,tico09_n_std             );		
		
        % evaluate TICO09 SNR
        fprintf(rpt_file, 'TICO09 SNR: %6.4f\n\n',eval_sroubek_snr_shift(im_orig, tico09, PSFsize));
        % write TICO09 image
        imwrite(tico09,[images{i} '_tico09.png'],'png');
    end 
    
    % run SROU03 deconvolution algorithm
    if run_srou03
        % delta function as parameter
        psf_noise = make_delta(PSFsize,PSFsize);

        psf_blur  = minh({im_blur},im_noise,[PSFsize PSFsize],'constr'); 
        psf_blur  = psf_blur{1};

        % shift psf blur towards the center
        psf_blur  = cntshift(psf_blur); 

        % estimation of gamma and lambda parameters
        lambda     = est_lambda({im_noise im_blur}, {psf_noise psf_blur}, [noise_n_std^2 blur_n_std^2]); 
        gamma      = est_gamma ({im_noise im_blur}, {psf_noise psf_blur}, [noise_n_std^2 blur_n_std^2]);

        lambdas    = [10   ]; 
        gammas     = [0.001]; 

        for j=1:size(gammas,2)
            for k=1:size(lambdas,2)
                % SROU03 MCAM
                tic; 
                [srou03, h_res] = blindMCIdeconv({im_noise im_blur},[],'RudOsh',lambdas(k),1e-1,gammas(j),[noise_n_std^2 blur_n_std^2],[],{psf_noise psf_blur},no_iter);
                toc;

                % resulting kernels
                srou03_psf01 = h_res{1}; 
                srou03_psf01 = srou03_psf01 / max(srou03_psf01(:));  

                srou03_psf02 = h_res{2}; 
                srou03_psf02 = srou03_psf02 / max(srou03_psf02(:));  

                % SROU03 output
                imwrite(srou03                     ,[images{i} sprintf('_%6.4f_%6.4f_srou03.png'      ,lambdas(k),gammas(j))],'png');
                % kernels output
                imwrite(srou03_psf01               ,[images{i} sprintf('_%6.4f_%6.4f_srou03_psf01.png',lambdas(k),gammas(j))],'png');
                imwrite(srou03_psf02               ,[images{i} sprintf('_%6.4f_%6.4f_srou03_psf02.png',lambdas(k),gammas(j))],'png');
                imwrite(psf_blur / max(psf_blur(:)),[images{i} sprintf('_%6.4f_%6.4f_srou03_psf00.png',lambdas(k),gammas(j))],'png');
				
				% evaluate bm3d statistics 
				srou03_mean   = mean(srou03(:));
				srou03_std    = std (srou03(:));
				srou03_n_stds = [IMM96_NoiseEstimation(srou03) TAI08_NoiseEstimation(srou03) MALL07_DWT_NoiseEstimation(srou03) MALL07_SWT_NoiseEstimation(srou03)]; 
				srou03_n_std  = mean(srou03_n_stds); 
				
				fprintf(rpt_file, 'Mean and standard deviation for the srou03 image for lambda %6.4f and gamma %6.4f        : %8.7f, %8.7f \n'              , lambdas(k), gammas(j), srou03_mean  , srou03_std   ); 
				fprintf(rpt_file, 'Estimated noise standard deviations for the srou03 image for lambda %6.4f and gamma %6.4f: %8.7f, %8.7f, %8.7f, %8.7f \n', lambdas(k), gammas(j), srou03_mean  , srou03_n_stds); 
				fprintf(rpt_file, 'Average noise standard deviation for the srou03 image for lambda %6.4f and gamma %6.4f   : %8.7f \n'                     , lambdas(k), gammas(j), srou03_n_std                );	

                fprintf(rpt_file, 'SROU03 SNR for lambda %6.4f and gamma %6.4f: %6.4f \n\n',lambdas(k),gammas(j), eval_sroubek_snr_scan(im_orig, srou03));
            end
        end
    end
    
    fprintf(rpt_file, '\n\n'); 
    
end

fclose(rpt_file); 
cd(THESIS_PATH); 







