function [coloraff,opticalflow_map] = computeInterFrameConnections(opticalflowdir,Data,nextIm,imname1,imname2,param,i)

% get squared color dist of connected nodes
[nr, nc, z] = size(nextIm);
nextData = double(nextIm(:));
nextData = reshape(nextData, [nr*nc 3]);

optdir=dir([opticalflowdir '/Forward*']);
% get connections between adjacent frames
opticalflowname = [opticalflowdir optdir(i).name];
vxy=readFlowFile(opticalflowname);
vx=vxy(:,:,1);
vy=vxy(:,:,2);

% if ~exist(opticalflowname)
%     im1=double(imread(imname1));
%     im2=double(imread(imname2));
%     flow = mex_LDOF(im1,im2);
% end
% load(opticalflowname,'vx','vy');      

xposMat = round(repmat([1:nc],[nr,1]) + vx);
yposMat = round(repmat([1:nr]',[1 nc]) + vy);

invalidNDx = (xposMat<=0)|(xposMat>nc)|(yposMat<=0)|(yposMat>nr);
xposMat(invalidNDx) = 1;
yposMat(invalidNDx) = 1;

opticalflow_map = sub2ind([nr,nc], yposMat, xposMat);

colordist = zeros(size(opticalflow_map));
for m=1:size(opticalflow_map,1)
    for n=1:size(opticalflow_map,2)
        thisNdx = sub2ind([nr,nc], m, n);
        colordist(m,n) = sum((Data(thisNdx,:)-nextData(opticalflow_map(m,n),:)).^2);
%         colordist(m,n) = slmetric_pw(Data(thisNdx,:)', nextData(opticalflow_map(m,n),:)', 'sqdist');
    end
end

beta_ = 1/(2*mean(colordist(:)));

% opticalflow_map(invalidNDx) = -1;
coloraff = param.gamma_*exp(-beta_*colordist);
coloraff(invalidNDx) = 0;