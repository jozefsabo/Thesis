%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pad image (expand by pixel values at the image's edge) 
%%% image      - image to be padded
%%% up         - number of pixels to pad up
%%% down       - ... down
%%% left       - ... left
%%% right      - ... right
%%% pad_result - padded image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pad_result = image_pad(image, up, down, left, right)

	width  = size(image,2);   
	height = size(image,1); 

	pad_img = zeros(height + up + down, width + left + right); 


	%Place the original matrix 'in the center'
	pad_img( (1:height) + up, (1:width) + left) = image; 

	%Fill the rectangular corners
	pad_img(1:up                             ,1     :left              ) = image(1,1); 
	pad_img(1:up                             ,(left + width + 1):end   ) = image(1,end);
	pad_img((up + height + 1):end            ,1     :left              ) = image(end,1);
	pad_img((up + height + 1):end            ,(left + width + 1):end   ) = image(end,end);



	%Fill the rectangular stripes
	for I=(1:left)
		pad_img((up + 1):(up + height)     ,  I                 ) = image(:,1  ); 
	end

	for I=(1:right)
		pad_img((up + 1):(up + height)     , (left + width + I)    ) = image(:,end); 
	end

	for I=(1:up)
		pad_img(I                         , (left + 1):(left+ width)   ) = image(1  ,:); 
	end

	for I=(1:down)
		pad_img((up + height + I)           , (left + 1):(left + width)   ) = image(end,:); 
	end

	pad_result = pad_img; 

end