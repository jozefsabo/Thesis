global_settings; 

name = '001_nois_ISO_1600_01_06_gray'; 

orthophoto   = im2double(imread('lena256_2cont2.png'));
unregistered = im2double(imread([name '.png']));


cpselect(unregistered, orthophoto); 

%mytform = cp2tform(input_points, base_points, 'projective');

%%% noisy source
%%% source    = [1235.7499999999998 411.24999999999955;1209.375 2303.625;3080.875 2328.375;3114.625 440.375]

%%%% use this for all Lena source images
regpoints = [241 141; 241 460;560 460;560 141]; 

mytform = cp2tform(input_points, regpoints, 'projective');



registered = imtransform(unregistered, mytform);

imwrite(registered, [name '_reg.png'], 'png'); 



