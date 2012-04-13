function [u, h, rmseu, rmseh, E] = blindMCIdeconv(g, r ,PotFce, ...
		u_lambda, u_mu, h_lambda, sigmas, u, h, no_iter, origu, origh)

% 
% Blind multichannel deconvolution algorithm based on 
% TV (or Mumford-Shah) regularization with cross-channel terms
% For mathematical and implementation details see paper
% Sroubek, Flusser, "Multichannel blind iterative image restoration". 
% IEEE Trans Image Processing 12(9):1094-1106, 2003.
% 
% Extended by Jozef Sabo at the Faculty of Mathematics and Physics 
% of the Charles University in Prague, Czech Republic
% as part of his 2012 diploma thesis entitled 
% "Image deblurring using two images with different exposure times"
% to accommodate variable noise per each input channel.   
%
% [U, H, rmseu, rmseh] = blindMCIdeconv(G,R,potfce,  
%                           u_lambda, u_mu, h_lambda, sigmas,
%                           u0, h0, no_iter, origu, origh)
%
% input arguments:
% G ... blurred images; cell array G = { image1, image2, ... imageP }
% R ... R matrix if empty use R=R2matrix(G,..) 
% potfce ... potential function (matlab fce) (e.g. 'RudOsh', 'MumShah' or 'HyperSruface')
% u_lambda, u_mu ... weights for U terms, potential and noise dependant
% h_lambda ... weight for the H term, noise dependant
% sigmas ... noise variances per each channel, a vector of the same
%            size as cell array G
% u0, h0 ... initial (starting) values of U and H (h0 cell array
% could be a set of empty matrices of size equal to overestimated
% blur size or just a size vector [s_y, s_x])
% origu ... original image (optional)
% origh ... original PSFs; cell aray (optional)
%
% output arguments:
% U ... restored image
% H ... restored blur masks; cell array
% rmseu ... RMS error of the estimated image if origu is given
% rmseh ... RMS error of the estimated blurs if origh cell array
% is given
%
% problem specification: G = conv2(U,H) + noise ; find U and H
%		partial-data case
% solution:  min(u,h_i) {BV(u) + hlambda*R(h_i) + ulambda*L2(h_i*u-g_i)}
%
% You can specify additional constraints on U and H by changing functions
% uConstr.m and hConstr.m

% note1: R is constructed via fft2 which is much faster for large R
% note(6.6.01): h_lambda can be a vector of coef-s that are
% used one by one and repeatedly, but if h_lambda (or u_lambda) is
% empty  then u_lambda (or h_lambda) is 
% assumed to be a noise variance sigma^2 and h_lambda (or u_lambda) is
% calculated from a fix product;  variable parprod see bellow (also see the paper)
% note(24.9.01): R may be defined as one of the input arguments
% written by Filip Sroubek (C) 2002
% extended by Jozef Sabo, 2012

% global variables (blurred images, restored image, reconstructed blur masks)
global G U H R

if ~isempty(g)
   G = g;
   clear g;
end
 

if var(vec([G{:}])) > 1
  disp('***** Warning ********');
  disp('Warning: Image standard deviation is over 1');
  disp('***** Warning ********');
end

% if no initial values are provided set u0=chopped(g) and h0 =
% direc(middle_point)

if iscell(h)
  hsize = size(h{1});
else
  hsize = h;
end
 
if isempty(r)
  disp('Calculating R matrix ...');
  % Modification by Jozef Sabo, 2012
  % R = R2matrix([],hsize,sigmas);
  R = fftR2matrix([],hsize,sigmas);
else
  R = r;
end
  
if ~iscell(h)
  clear h;
  disp(['Setting size of H to ',num2str(hsize(1)),'x',num2str(hsize(2))]);
  disp(['Initializing H to Dirac pulses at ...']);
  hextra = findH(R,length(G),hsize);
  dcH = zeros(length(G),2);
  dcH(1,:) = cog(hextra{1});
  for k = 2:length(G)
    dcH(k,:) = round(cog(hextra{k})-dcH(1,:));
  end
  dcH(1,:) = 0;
  cc = (hsize+1)/2 - (max(dcH) + min(dcH))/2;
  dcH = round(dcH+repmat(cc,length(G),1));
  dcH
  if sum(min(dcH) < [1 1] ) | sum(max(dcH) > hsize)
    disp(['Positions out of bounds. Size of blurs is probably too' ...
	  ' small.']);
    disp('Initializing H to Dirac pulses in the center');
    dcH = repmat(ceil(hsize/2),length(G),1);
  end
  for k = 1:length(G);
    h{k} = zeros(hsize);
    h{k}(dcH(k,1),dcH(k,2)) = 1;
  end
elseif sum(h{1}(:)) == 0
  disp('Initializing H to Dirac pulses in the center');
  for k = 1:length(G)
    mid = ceil(hsize/2);
    h{k}(mid(1),mid(2)) = 1;
  end
else
  disp('Imposing conditions on H');
  for k=1:length(G)
    h{k} = hConstr(h{k});
    if sum(mod(hsize,2)) ~= 2
      disp('Warning: even size of the mask H');
    end
  end
end

U = zeros(size(G{1})+size(h{1})-1);
if isempty(u) 
   disp('Setting the initial u0 to zero.');
elseif sum(size(u) ~= (size(G{1}) + size(h{1})  - 1))
   disp('Warning: Size u0 is different than expected.');
   disp('Cropping...');
   U = u(1:size(U,1),1:size(U,2));
else
    U = u;
end
if exist('origu') 
  origu = origu(size(h{1},1):end-size(h{1},1)+1,...
		size(h{1},2):end-size(h{1},2)+1);
  chop = -size(origu)+(size(U)-2*size(h{1})+2);
end

if ~exist('no_iter')
  no_iter = 100;
end
rmseu = [];
rmseh = [];

%% normalize the original image and original blurs
if exist('origu')
    origu = (origu-mean(origu(:)))/sqrt(var(origu(:)));
end
if exist('origh');
  p = sum(vec([origh{:}]))/length(G);
  for i = 1:length(origh)
    origh{i} = origh{i}/p;
  end
end

% intensity value interval of the input images
vrange = [min(vec([G{:}])), max(vec([G{:}]))];
%
% AM algorithm
%

H = h;

% inverted input variances, modification by Jozef Sabo, 2012 
gammas = 1./sigmas; 
 
% param. product 
% parprod = 1/(4+2*sqrt(2))*sqrt(prod(size(h{1}))/(length(G)*prod(size(G{1}))));
% modification by Jozef Sabo, 2012
parprod =  (1/((4+2*sqrt(2))*sum(gammas(1:end-1))))*sqrt((prod(size(h{1})) /prod(size(G{1})) )*sum(gammas(:)));

%%% parprod == ?
if (isempty(h_lambda))
  disp('Estimating h_lambda from u_lambda');
  h_lambda = parprod*u_lambda;
end
if (isempty(u_lambda))
  disp('Estimating u_lambda from h_lambda');
  u_lambda = h_lambda/parprod;
end

QUIET = 1;
if (exist('origu') | exist('origh')) & (~QUIET) 
  errpic = figure('Tag','errpic');
end
if ~QUIET
  upic = figure('Tag','upic');
  figure(upic);
  axes('position',[0.25,0.01,0.5,0.01]);
  axis off;
  title([PotFce,' U(\lambda,\mu)=(',num2str(u_lambda),',', ...
	 num2str(u_mu),')', ' H(\lambda)=(',num2str(h_lambda), ...
	 ')']);
  subplot(2,2,4);
  dispIm(G{1});
  drawnow;
  stopButton = uicontrol('Style','pushbutton','String','Stop 1', ...
			 'Position',[0 0 80 20], 'CallBack', ...
			 'set(gcf,''UserData'',[1])');
  set(upic,'UserData',[0]);
end
if QUIET
  upic = [];
  errpic = [];
end

h_lambda_set = kron(ones(1,no_iter),h_lambda); 


for j = 1:no_iter   
  
  disp(['Step: ',num2str(j)]);
  % U minimization
  disp('U minimization');
  % modification by Jozef Sabo, 2012
  [iresu E] = minUstep(PotFce,u_lambda,u_mu,sigmas,1,1e-6);
  % impose constraints on U 
  U = uConstr(U,vrange);
  % H minimization 
  disp('H minimization');
  % modification by Jozef Sabo, 2012
  iresh = minHIstep(PotFce,u_lambda,h_lambda_set(j),sigmas,5,1e-6);
  % impose constraints on H
  for k=1:length(H)
    H{k} = hConstr(H{k});
	% shift kernel towards the center
	% modification by Jozef Sabo, 2012
	H{k}  = cntshift(H{k}); 
  end

  
  [b1 b2] = size(h{1});  
  u = U(b1:end-b1+1, b2:end-b2+1);
  
  if ~QUIET
    figure(upic);
    subplot(2,2,1); dispIm(u);
    subplot(2,2,3); dispIm([H{:}]);
    subplot(2,2,2); %semilogy(iresh{end,end});
    dispIm(E);
    set(stopButton,'String',['Stop ',num2str(j)]);
    drawnow;
  end

  if exist('origu');
    e = zeros(chop+1);
    for k=0:chop(1)
      for l=0:chop(2)
	e(k+1,l+1) = pmse(u(1+k:end-(chop(1)-k),1+l:end-(chop(2)-l)),origu);
      end
    end
    disp(['rmse(u): ',num2str(min(e(:)))]); 
    rmseu = [rmseu; min(e(:))];
    if ~QUIET
      figure(errpic);
      subplot(2,1,1);
      bar(rmseu);
      drawnow;
    end
  end
  if exist('origh')
    errj = 0;
    errc = 0;
    for i=1:length(H)
      b = size(H{i})-size(origh{i});
      p = sum(vec([H{:}]))/length(H);
      e = zeros(b+1);
      for k=0:b(1)
	for l=0:b(2) 
	  e(k+1,l+1) = norm(origh{i}-H{i}(k+1:end-b(1)+k,l+1:end- ...
					  b(2)+l)/p,'fro')^2;
	end
      end
      errj = errj+min(e(:));
      errc = errc+norm(origh{i},'fro')^2;
    end
    err = 100*sqrt(errj/errc);
    disp(['rmse(h): ', num2str(err)]); 
    rmseh = [rmseh; err];
    if ~QUIET 
      figure(errpic);
      subplot(2,1,2);
      bar(rmseh);
      drawnow;
    end
  end
  if get(upic,'UserData') 
    break;
  end
end

p = sum(vec([H{:}]))/length(H);
for i = 1:length(H)
  h{i} = H{i}/p;
end
u = u*p;

uw = U([1:size(G{1},1)]+floor((b1-1)/2),[1:size(G{1},2)]+floor((b2-1)/2));
clear global U H;


  
   



