function SNR = eval_sroubek_snr(I,E)
%
% Signal-to-Noise Ratio in dB
%
% SNR = snr(I,E)
% 
% I ... original image
% E ... estimated image of which SNR we want to calculate
%
% Note: a linear transform of intesity values of E is applied to 
% minimize MSE between E and I 


%% linear transform of intensity values of E to minimize MSE 

%a = [sum(E(:).^2), sum(E(:))];
%ATA = [a; a(2) length(E(:))];
%b = [(E(:)).'*I(:); sum(I(:))];
%p = ATA\b;
%E = p(1)*E+p(2);
E = ((E(:)-mean(E(:))).'*(I(:)-mean(I(:))))/var(E(:))/numel(E) * E;

SNR = 10*log10(var(I(:)) / var(I(:)-E(:)));
