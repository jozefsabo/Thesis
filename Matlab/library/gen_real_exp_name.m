function exp_name = gen_real_exp_name(images, PSFs, run_srou03, run_tico09, run_bm3d)
    img_str = images{1}; 
    psf_str = sprintf('%d',PSFs(1)); 
    met_str = ''; 
    srou03_str = ''; 
    tico09_str = ''; 
    bm3d_str   = ''; 
    
	for i =  2:size(images{:})
        img_str = [img_str ' ' images{i}]; 
    end	
    
    for i =  2:size(PSFs{:})
        psf_str = [img_str ' ' sprintf('%d',PSFs(i))]; 
    end
 
    
	
	exp_name = sprintf('%s %s %s %s',img_str); 

end