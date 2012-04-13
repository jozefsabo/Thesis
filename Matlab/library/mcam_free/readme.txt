How to use blindMCIdeconv m-file?

You can add constraints on PSFs and original image by editing
uConstr.m and hConstr.m, respectively.
However this procedure is not recommended, since the convergence of
the algorithm can be affected.
If you know the correct blur size then to speed up the computation
it is recommended to use the simple minimization 1. (Gaussian elimination)
instead of the minimization 2. (fmincon) in minHIstep.m. Fmincon is part of 
the Optimization ToolBox. 

note: The input images should be normalized to have variance equal to 1!!!
Otherwise, you must adjust the input weights appropriately.

examples:
% load 3 PSFs of size 5x5 into h
load blurs5x5

% load test image
I = double(imread('lena2.png'));

% convolve I with h, add noise 40dB, no shift between images
G = convshift(I,h,40,[0 0]);

% perform blind deconvolution, TV regularization,
% 1. weight (u_lambda) 1e4 = 1/(noise variance), e.g. for 30db use 1e3
% 2. weight (u_mu) is epsilon = 1e-1 (approximation of TV norm)
% 3. weight (h_lambda) is calculated automatically
% estimated size of blurs is 5x5
% 10 iterations
[u, hr] = blindMCIdeconv(G,[],'RudOsh',1e4,1e-1,[],[],[5 5],10);

% same as above but with the overestimated blur size 7x7
% here it is advisable to specify 3. weight (h_lambda) and set it
% to a smaller value than the automatically calculated one.
[u, hr] = blindMCIdeconv(G,[],'RudOsh',1e4,1e-1,[],[],[7 7],10);

% same as above but using Mumford-Shah regularization
% here 2. weight (u_mu) penalizes the length of discontinuities
[u, hr] = blindMCIdeconv(G,[],'MumShah',1e4,1e1,[],[],[5 5],10);
