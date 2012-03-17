%Color transfer function as described by Gooch et al. (2001) generalized to any colorspace
%SourceImage - source image 
%TargetImage - target image
%ResultImage - result image

function ResultImage = general_color_transfer(SourceImage, TargetImage)

sourceXstd = std2(SourceImage(:,:,1));
sourceYstd = std2(SourceImage(:,:,2));
sourceZstd = std2(SourceImage(:,:,3));

sourceXavg = mean2(SourceImage(:,:,1));
sourceYavg = mean2(SourceImage(:,:,2));
sourceZavg = mean2(SourceImage(:,:,3));

targetXstd = std2(TargetImage(:,:,1));
targetYstd = std2(TargetImage(:,:,2));
targetZstd = std2(TargetImage(:,:,3));

targetXavg = mean2(TargetImage(:,:,1));
targetYavg = mean2(TargetImage(:,:,2));
targetZavg = mean2(TargetImage(:,:,3));

ratioX = sourceXstd / targetXstd; 
ratioY = sourceYstd / targetYstd;
ratioZ = sourceZstd / targetZstd;


TargetImage(:,:,1) = TargetImage(:,:,1) - targetXavg;
TargetImage(:,:,2) = TargetImage(:,:,2) - targetYavg;
TargetImage(:,:,3) = TargetImage(:,:,3) - targetZavg;

TargetImage(:,:,1) = TargetImage(:,:,1)* ratioX;
TargetImage(:,:,2) = TargetImage(:,:,2)* ratioY;
TargetImage(:,:,3) = TargetImage(:,:,3)* ratioZ;

TargetImage(:,:,1) = TargetImage(:,:,1) + sourceXavg;
TargetImage(:,:,2) = TargetImage(:,:,2) + sourceYavg;
TargetImage(:,:,3) = TargetImage(:,:,3) + sourceZavg;


ResultImage = TargetImage; 

end