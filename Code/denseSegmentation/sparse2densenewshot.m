function sparse2densenewshot(videoFile)
 

% %%%%%%%%%%
% 
% INPUT - default in ()
% BPLR_ (1): 0 - color likelihood only; 1 - full model (with partial shape match)
% 
% param.fgNbStates (5): # of fg GMMs
% param.bgNbStates (5): # of bg GMMs
% param.alpha_ (0.5): color-cost vs. partial shape match cost
% param.gamma_ (4): smoothness weight; use 50 for color-only (i.e., if BPLR_=0)
% 
% param.hypothesisNum (1): rank of hypothesis to process for video segmentation
% param.skip (1): # of frames to skip for hypothesis discovery.  Increase to reduce computation time
% param.numTopRegions (10): # of regions to consider per frame for hypothesis discovery
% param.knn (5): # parameter for constructing k-nn graph for hypothesis discovery
%  
% param.imdir: video frame directory (code assumes that images will be either jpg, png, or bmp)
% param.opticalflowdir:optical flow directory
% param.regiondir: region proposals directory
% param.bplrdir: bplr directory
%
% OUTPUT
% our_mask: binary segmentation of video corresponding to hypothesis param.hypothesisNum
% Segs: top regions per frame
% selind: selected regions across video
%
% Yong Jae Lee, 7/26/2012
% %%%%%%%%%%



%% parameters
%%%%%%%%%%
load(['./Data/' videoFile '/sparsesetimages.mat']);
if ~exist(['./Data/' videoFile '/result'],'dir')
    mkdir(['./Data/' videoFile '/result']);
end
BPLR_ = 0;numFrames=90;
param.fgNbStates = 3;
param.bgNbStates = 5;
param.alpha_ = 0.5;
if BPLR_ == 1
    param.gamma_ = 10;
else
    param.gamma_ = 50;
end
param.skip = 1;
param.numTopRegions = 10;
param.knn = 5;
param.imdir = ['./Data/' videoFile '/frames/'];
param.bplrdir = ['./Data/' videoFile '/frames/bplr/'];
param.opticalflowdir = ['./Data/' videoFile '/frames/' videoFile 'Results/'];
img_dir=dir([param.imdir '*.ppm']);
tic;
fprintf(['Computing GMMs...']);
% get the foreground and background points and slic of it
[fg,bg] = gmmKeySegs(param.imdir,setimages,param,numFrames);
disp(['done [' num2str(toc) ' seconds]']);
% finalToc = [finalToc toc];

if BPLR_ == 1
    tic;
    fprintf(['Loading BPLRs of hypothesis...']);
    [fgFeats bgFeats] = getKeySegmentBPLRFeatures(setimages, param.bplrdir,numFrames,videoFile);
    disp(['done [' num2str(toc) ' seconds]']);
%     finalToc = [finalToc toc];
end
tic;
fprintf(['Computing color and shape likelihoods...']);
for i=1:numFrames
    i
    imname = img_dir(i).name;        
    im = imread([param.imdir '/' imname]); 
    [nr, nc, z] = size(im);
    
    %% compute color likelihoods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [fgpim,bgpim,Data] = computePosteriors(im,nr,nc,param,fg,bg);    
    % adjust posteriors if frame contains keysegment
%     if keyFrames(i) == 1
        [fgpim,bgpim,bgind] = adjustPosteriors(setimages,nr,nc,i,fgpim,bgpim);
%     end    
    Dc = cat(3, bgpim, fgpim);
    
    % get vertical and horizontal smoothness
    [Hc,Vc] = computeSmoothness(im,param);
    
    frame(i).Dc = Dc;    
    frame(i).Hc = Hc;
    frame(i).Vc = Vc;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
%     %% compute partial shape match
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if BPLR_ == 1
    %     try
               bplr_file = [param.bplrdir 'BPLR_' sprintf('%04d',i) '.mat'];
            [shapeMask, pred_fg_bplrs] = computePartialShapeMatch(bplr_file,fgFeats,bgFeats,setimages,nr,nc);

%             if keyFrames(i) == 1
                shapeMask(bgind) = 0;
%             end
            if isempty(pred_fg_bplrs)
                frame(i).BPLR_Dc = 0.5*ones(nr, nc, 2);
            else
                frame(i).BPLR_Dc = cat(3, 1-shapeMask, shapeMask);
            end
    %     catch
    %         frame(i).BPLR_Dc = 0.5*ones(nr, nc, 2);
    %     end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
    %% compute inter frame connections
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (i~=numFrames)
        nextIm = imread([param.imdir img_dir(i+1).name]); 
        [coloraff,opticalflow_map] = computeInterFrameConnections(param.opticalflowdir,Data,nextIm,[param.imdir img_dir(i).name],[param.imdir img_dir(i+1).name],param,i);
        
        frame(i).opticalflow_map = opticalflow_map;
        frame(i).opticalflow_coloraff = coloraff;
    else
        frame(i).opticalflow_map = [];
        frame(i).opticalflows_coloraff = [];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
end
disp(['done [' num2str(toc) ' seconds]']);
% finalToc = [finalToc toc];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% compute segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
fprintf(['Compute segmentation for entire video...']);
our_mask = computeSegmentation(numFrames,nr,nc,param,frame,BPLR_);
disp(['done [' num2str(toc) ' seconds]']);
% finalToc = [finalToc toc];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp(['Total: ' num2str(sum(finalToc)) ' seconds']);
mask=zeros(size(our_mask));
for i=1:size(our_mask,3)
obj=setimages{i};
[y,x] = find(obj==1);
% miny = max(1,min(y)-50); minx = max(1,min(x)-80); 
% maxy = min(nr,max(y)+50); maxx = min(nc,max(x)+50);
% mask(miny:maxy,minx:maxx,i)=our_mask(miny:maxy,minx:maxx,i);
mask=our_mask;
imshow(imread(['./Data/' videoFile '/frames/' img_dir(i).name]));
hold on
h=imshow(mask(:,:,i));
 set(h, 'AlphaData', 0.5);
 pause(0.5);
   n = sprintf('%04i',i)
    saveas(h,['./Data/' videoFile '/result/result' num2str(n) '.jpg'])

    close all
end
save(['./Data/' videoFile '/result/segment_.mat'],'mask')
