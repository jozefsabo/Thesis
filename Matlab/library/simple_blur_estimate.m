%g1 = noisy image
%g2 = blurred and less noisy image

function out_kernel = simple_blur_estimate(g1, g2, blur_size, num_iter, num_kernel)

%sizes of input images are not equal
if (size(g1) ~= size(g2)) 
    error('Simple blur estimate: sizes of input images are not equal'); 
end 

%number of maximum "windows" possible
rangeY   = size(g1,1) - blur_size; 
rangeX   = size(g1,2) - blur_size;   
max_iter = rangeX     * rangeY; 

%handling the potentially larger number of iterations than possible
if (num_iter > max_iter)
    num_iter = max_iter;  
end    

g1_cell = cell(1, num_kernel); 
g2_cell = cell(1, num_kernel);

max_var = -Inf; 

%go through all the possible "window" locations
tic; 
% for i=1:rangeX
%     for j=1:rangeY


for l=1:num_iter 

        i = floor((rangeX-1)*rand()) + 1;
        j = floor((rangeY-1)*rand()) + 1;
    
    
        cur_win_g1 = g1(j + (0:blur_size - 1), i + (0:blur_size - 1));        
        cur_win_g2 = g2(j + (0:blur_size - 1), i + (0:blur_size - 1));
        cur_var = var(cur_win_g1(:)); 
        
        if (cur_var > max_var)

%           g1_cell{1, 2:num_kernel} = g1_cell{1, 1:num_kernel-1}; 
%           g2_cell{1, 2:num_kernel} = g2_cell{1, 1:num_kernel-1}; 
            
            for k=1:num_kernel-1
                g1_cell{1, num_kernel - k + 1} = g1_cell{1, num_kernel - k};
                g2_cell{1, num_kernel - k + 1} = g2_cell{1, num_kernel - k};
            end

            g1_cell{1,1} = cur_win_g1; 
            g2_cell{1,1} = cur_win_g2; 
            
            s = sprintf('X and Y: %i, %i',i, j); 
            disp(s); 
            
%             g3 = g1; 
%             
%             g3( j + (0:blur_size - 1), i                   ) = 1; 
%             g3( j + (0:blur_size - 1), i  +   blur_size - 1) = 1; 
%             g3( j                   , i + (0:blur_size - 1)) = 1; 
%             g3( j +   blur_size - 1 , i + (0:blur_size - 1)) = 1; 
%             
%             putimages(g3); 
            
            max_var = cur_var; 
        end

end
        
%     end
% end
toc;

%construct the equation

A = zeros(num_kernel, blur_size^2); 
B = zeros(num_kernel, 1);  

cX =  blur_size - floor(blur_size/2);  

try
for i=1:num_kernel
   
    A(i, 1:end) = reshape((g1_cell{1,i})', 1, []); 
    B(i, 1    ) = g2_cell{1,i}(cX, cX); 
    
    %debug
    putimages(g1_cell{1,i }, g2_cell{1,i}); 
    
end    

catch
    
end    

out_kernel = A\B; 
out_kernel = reshape(out_kernel, blur_size, blur_size)'; 

out_kernel = out_kernel + abs(min(out_kernel(:))); 
out_kernel = out_kernel / sum(out_kernel(:)); 







%calculate blur

end