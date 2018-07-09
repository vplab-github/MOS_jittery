function getBlockwiseTraj_ud(videoFile,blocksize)
% divide into block
% load coordinates
% for each block
if ~exist(['./Data/' videoFile '/readTraj.mat'])
readpoints(['./Data/' videoFile '/'],'Tracks.dat','readTraj.mat');
end
load(['./Data/' videoFile '/readTraj.mat']);
for i = 1: size(TrajectoryCoordinates,1)
    [row,~] = find(TrajectoryCoordinates{i}~=0);
    uniqrow = unique(row);
    frames(uniqrow,i)=1;
   
end
k=1;

gtim = imread(['./Data/' videoFile '/frames/gt/0001.jpg']);
 [gtx, gty] = find(gtim(:,:,1)>200);
trajids = find(frames(1,:)~=0);
foretrajids{k}=[];foretrajcoord{k}=[];backtrajids{k}=[];backtrajcoord{k}=[];
for i=1:size(trajids,2)
trajcoord = TrajectoryCoordinates{trajids(i)}(1,:);
ind=find(gty==trajcoord(1)& gtx==trajcoord(2));
if size(ind,1)~=0
    foretrajids{k}=[foretrajids{k};trajids(i)];
    foretrajcoord{k}=[foretrajcoord{k};TrajectoryCoordinates{trajids(i)}(1,:)];

else
     backtrajids{k}=[backtrajids{k};trajids(i)];
    backtrajcoord{k}=[backtrajcoord{k};trajcoord];%TrajectoryCoordinates{trajids(j)}(i,:)];
 
end
end

% get the foreground and background trajectories
for i=20:20:numFrames
    k=k+1;

   % get the foreground and background trajectories
   gtnum=sprintf('%04d.jpg',i);
   gtim = imread(['./Data/' videoFile '/frames/gt/' gtnum]);
   [gtx, gty] = find(gtim(:,:,1)>200);
trajids = find(frames(i,:)~=0);
foretrajids{k}=[];foretrajcoord{k}=[];backtrajids{k}=[];backtrajcoord{k}=[];

for jj=1:size(trajids,2)
trajcoord = TrajectoryCoordinates{trajids(jj)}(i,:);
ind=find(gty==round(trajcoord(1))& gtx==round(trajcoord(2)));
if size(ind,1)~=0
  foretrajids{k}=[foretrajids{k};trajids(jj)];
    foretrajcoord{k}=[foretrajcoord{k};trajcoord];%TrajectoryCoordinates{trajids(j)}(i,:)];
else
     backtrajids{k}=[backtrajids{k};trajids(jj)];
    backtrajcoord{k}=[backtrajcoord{k};trajcoord];%TrajectoryCoordinates{trajids(j)}(i,:)];
 
end
end  % coordinates

   % save the clusters
%    visualize_sparse_save(videoFile,i,blocksize);
   
end
 save(['./Data/' videoFile '/forebackcoord.mat'],'foretrajids','backtrajids');
end