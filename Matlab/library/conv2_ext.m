%Extended convolution - pad A by the size of B and then perform 'valid' conv2

function conv_result = conv2_ext(A,B)

%if one of the dimensions of B is zero, return the input
if (min(size(B,1), size(B,2)) == 0) 
    conv_result = A; 
else
    A_w = size(A,2); 
    A_h = size(A,1);

    B_w = size(B,2); 
    B_h = size(B,1);

    B_u = floor(B_h/2); 
    B_d = B_h - B_u - 1; 
    B_l = floor(B_w/2); 
    B_r = B_w - B_l - 1; 


    % OLD METHOD Create a larger matrix
    % A_ext = zeros(A_h + B_h - 1, A_w + B_w - 1);   
    % 
    % %Place the original matrix 'in the center'
    % A_ext( (1 + B_u):(B_u + A_h), (1 + B_l):(B_l + A_w) ) = A;    
    % 
    % 
    % %Fill the rectangular corners
    % A_ext(1:B_u                             ,1     :B_l            ) = A(1,1); 
    % A_ext(1:B_u                             ,(B_l + A_w + 1):end   ) = A(1,end);
    % A_ext((B_u + A_h + 1):end               ,1     :B_l            ) = A(end,1);
    % A_ext((B_u + A_h + 1):end               ,(B_l + A_w + 1):end   ) = A(end,end);
    % 
    % 
    % 
    % 
    % 
    % %Fill the rectangular stripes
    % 
    % for I=(1:B_l)
    %     A_ext((B_u + 1):(B_u + A_h)     ,  I                 ) = A(:,1  ); 
    % end
    % 
    % for I=(1:B_r)
    %     A_ext((B_u + 1):(B_u + A_h)     , (B_l + A_w + I)    ) = A(:,end); 
    % end
    % 
    % for I=(1:B_u)
    %     A_ext(I                         , (B_l + 1):(B_l + A_w)   ) = A(1  ,:); 
    % end
    % 
    % for I=(1:B_d)
    %     A_ext((B_u + A_h + I)           , (B_l + 1):(B_l + A_w)   ) = A(end,:); 
    % end

    A_ext = image_pad(A, B_u, B_d, B_l, B_r); 

    conv_result = conv2(A_ext, B, 'valid'); 
end
end 