clear all;

addpath(genpath('./'));

videoFile='climb';

blocksize = 35; overlap=10; 
system('make');
system('sudo cp libldof_gpu.so /usr/lib');
system('sudo chmod 0755 /usr/lib/libldof_gpu.so');
% s = system(['ffmpeg -i ' videoFile '.avi %04d.ppm']); 

SplitandGenTrajectory(videoFile);

getBlockwiseTraj(videoFile,blocksize,overlap);
%param Stabilization
lambda1=0.5;lambda2=0.5;
StabilizeTraj(videoFile,lambda1,lambda2);

%param PLSA
p=3; sigma=0.003;
TrajClust=findClusters(videoFile,sigma,p);

% plot points
visualizeSparseSegmentation(videoFile,TrajClust)

%Create object proposal
ObjectProposalcopy(videoFile);

%param GraphCut
sparse2densenewshot(videoFile);
