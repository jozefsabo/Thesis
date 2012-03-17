function [G, x, sigma2] = convshift(x, h, snr, shift)
%
% G = convshift(x, h, snr, shift)
% Multichannel convolution with optional noise and shift
% Convolve x with h-s (cell array) add white noise (SNR) and shift
% results; returns a cell array of blured noisy images with size
% equal to the original image 
%    
  
  
  if ~exist('shift')
    shift = [5 5];
  end
  if ~exist('snr');
    snr = [];
  end
  if snr == Inf
    snr = [];
  end
  
  maxsize = size([h{:}],1);
  s = zeros(length(h),2);
  s(1:4,:) = [ 0 0; shift; 0 shift(2); shift(1) 0]; 
  % normalize the original signal
  x = x-mean(x(:));
  x = x/sqrt(var(x(:)));
  sigma2 = 0;
  for i = 1:length(h)
    G{i} = conv2(x,h{i}, 'valid');
    if ~isempty(snr)
      vn = sqrt(var(G{i}(:),1)/(10^(snr/10)));
      sigma2 = vn^2;
      G{i} = G{i} + vn*randn(size(G{i}));
    end
    G{i} = G{i}(s(i,1)+1:end-shift(1)+s(i,1), s(i,2)+1:end-shift(2)+s(i,2)); 
  end
  
  


