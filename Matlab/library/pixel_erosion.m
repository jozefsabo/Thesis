%Simple pixel erosion 
%source_image - source image
%result_image - result image 
function result_image = pixel_erosion(source_image)

src_img = source_image; 

eroded_pixels = 1; 

height = size(src_img, 1);
width  = size(src_img, 1);

while (eroded_pixels > 0)

    eroded_pixels = 0; 
    
    
    for I=1:width
        for J=1:height
            sub_img = src_img(lowcut(J-1,1):hicut(J+1,height), lowcut(I-1,1):hicut(I+1, width));

            if (sum(sub_img(:)) > 1)
                src_img(J,I) = 0;  
                eroded_pixels = eroded_pixels + 1; 
            end    
        end
    end

end

result_image = src_img; 

end