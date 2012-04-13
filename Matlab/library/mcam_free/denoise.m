function [U, E] = denoise(I,method,lambda,mu,no_iter)
  
% 
%  [U, E] = denoise(I,method,lambda,no_iter,origI)
%
% Denoising and/or segmentation procedure based on the minimization of
% Mumford-Shah functional or total variation integral
% This M-file is just a simple wrapper for the more powerfull
% blindMCIdeconv M-file which can do deconvolution as well.
%
% input arguments:
% I ... original image
% method ... 'RudOsh' or 'MumShah' (MumShah is better for segmentation)
% lambda ... inverse value of noise variance (or 1/weight of the
%            segmentation term); smaller value => stronger denoising 
% mu ... weight of the discontinuity term; larger value => less
%        edges
% no_iter ... number of iterations
% 
% output arguments
% U ... denoised and/or segmented image I
% E ... edge image
% 
% written by Filip Sroubek (c) 2003
%

  
  [U,hr,rmseu,rmseh,E] = blindMCIdeconv({I},[0],method,lambda,mu,0, ...
					I,{1},no_iter);
  