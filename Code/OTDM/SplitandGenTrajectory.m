function []=SplitandGenTrajectory(videoFile)
%% split the frames ppm format
cd(['./Data/' videoFile '/frames'])
img_dir=dir('*.ppm');
numFrames=size(img_dir,1);
cd ../../../
%% point trajectory generation command
% write bmf file
if ~exist(['./Data/' videoFile '/frames/' videoFile '.bmf'])
fileID = fopen(['./Data/' videoFile '/frames/' videoFile '.bmf'],'w');
 fprintf(fileID,[num2str(numFrames) ' 1\n']);
for i=1:size(img_dir,1)
    fprintf(fileID,[img_dir(i).name '\n']);
end
s=[videoFile '.bmf'];
fclose(fileID);
end
%./tracking bmfFile startFrame numberOfFrames sampling
system(['./tracking ./Data/' videoFile '/frames/' videoFile '.bmf 0 ' num2str(numFrames-1) ' 4']); 
%% move Tracks file and rename 
system(['mv ' ['./Data/' videoFile '/frames/' videoFile 'Results/' videoFile 'Track*.dat'] ' ' ['./Data/' videoFile '/Tracks.dat']]);
end