function xcorr_res = cross_corelation(A,B)

size_out  = abs(size(A) - size(B)) + [1 1]; 
xcorr_res = zeros(size_out);  

for i = 1:size(xcorr_res, 1)
    for j = 1:size(xcorr_res, 2)
        
        B_sub  = B( (1:size(A,1)) + i - 1, (1:size(A,2)) + j - 1); 
        AB_sub = A.*B_sub; 
        
        imshow(AB_sub); 
        
        xcorr_res(i,j) = sum(AB_sub(:));
        
    end
end    

xcorr_res = xcorr_res + abs(min(xcorr_res(:))); 
xcorr_res = xcorr_res / max(xcorr_res(:)); 

end