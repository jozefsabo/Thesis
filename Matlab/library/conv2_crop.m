%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Crop image %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% crop_in - input
%%% crop_by - crop by 
%%% crop_res- result
%%%%%%%%%%%%%%%%%%%%%%%%%%
function crop_res = conv2_crop(crop_in, crop_by)

    [up down left right] = conv2_shifts(crop_by); 

    crop_res = crop_in (up + (1:(size(crop_in,1) - up - down)), left + (1:(size(crop_in,2) - left - right)));  

end