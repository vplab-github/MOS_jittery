function getBlockwiseTraj(videoFile,blocksize,overlap)
if ~exist(['./Data/' videoFile '/readTraj.mat'])
readpoints(['./Data/' videoFile '/'],'Tracks.dat','readTraj.mat');
end
load(['./Data/' videoFile '/readTraj.mat'],'numFrames')
%% from TrajCoord to valid
fullTraj1(videoFile,['./Data/' videoFile '/readTraj.mat'],blocksize,numFrames,'validTraj.mat',overlap);
% system(['mv validTraj.mat ./Data/' videoFile '/']);
end