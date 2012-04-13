%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Noise estimation testing script %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% run the global settings
global_settings; 

% create a test directory and switch to it
test_dirname = mk_test_dir(OUTPUT_PATH, 'SABO11_NoiseEstimationTest'); 
cd(test_dirname); 

% create a report file
rpt_file = mk_report_file([test_dirname '\'], 'report.csv'); 

% images to test on
images  = {'lena256.png' 'tree256.png' 'text256.png' 'castle256.png'};
% standard deviations
stds    = (0:0.0001:0.02); 
% methods 
methods = {'TAI08_NoiseEstimation', 'IMM96_NoiseEstimation', 'MALL09_SWT_NoiseEstimation', 'MALL09_DWT_NoiseEstimation'};
% result strings
res_str = methods; 


first_line = 'Input file,Input STD,IMM96,TAI08,MALL09 SWT,MALL09 DWT\n'; 
fprintf(rpt_file, first_line);

imm96 = zeros(1,size(stds)); 
tai08 = zeros(1,size(stds)); 
swt07 = zeros(1,size(stds)); 
dwt07 = zeros(1,size(stds)); 


for i = 1:size(images(:)) 
    
    im_source = im2double(imread(images{i})); 
    
    for j=1:size(stds(:))
        
        im_noise = imnoise(im_source, 'gaussian', 0, stds(j).^2); 
        
        imm96(j) = IMM96_NoiseEstimation(im_noise) / stds(j);  
        tai08(j) = TAI08_NoiseEstimation(im_noise) / stds(j);
        swt07(j) = MALL09_SWT_NoiseEstimation(im_noise) / stds(j); 
        dwt07(j) = MALL09_DWT_NoiseEstimation(im_noise) / stds(j);
        
        out_line = sprintf('%s,%10.9f,%6.4f,%6.4f,%6.4f,%6.4f\n',images{i},stds(j),imm96,tai08,swt07,dwt07);
        fprintf(rpt_file, out_line);
    end
    
end

plot(stds, imm96, stds, tai08, stds, swt07, stds, dwt07); 

% close the output file
fclose(rpt_file); 

%change directory back to global (thesis)
cd(THESIS_PATH); 


