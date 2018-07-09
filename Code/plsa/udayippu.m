clear all;

addpath(genpath('./'));
folder='./Data/';
videoFile='shot7';

blocksize = 20;%overlap=5;
system('make');
system('sudo cp libldof_gpu.so /usr/lib');
system('sudo chmod 0755 /usr/lib/libldof_gpu.so');
s = system(['ffmpeg -i ' videoFile '.avi %04d.ppm']); 

SplitandGenTrajectory(videoFile);


getBlockwiseTraj_ud(videoFile,blocksize);

% get SLIC
getObjectProposal(videoFile,blocksize)
% sparse2dense
getBPLRfiles(videoFile);
sparse2dense(videoFile)