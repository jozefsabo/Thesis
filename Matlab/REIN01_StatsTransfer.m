%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A simple image statistics transfer method by Reinhard et al. (2001) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% img_source - the source image 
%%% img_target - the target image
%%% out_img    - the resulting image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_img = REIN01_StatsTransfer(img_source, img_target)
	
	src_mean = mean2(img_source); 
	tgt_mean = mean2(img_target);
    
    src_std  = std2(img_source);
    tgt_std  = std2(img_target);

    out_img  = (img_target - tgt_mean).*(src_std / tgt_std) + src_mean; 
    
end