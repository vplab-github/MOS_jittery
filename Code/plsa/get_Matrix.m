function [] = get_Matrix(Trajname,validTrajname)
%----------------------------------
rand('state',0);
%----------------------------Set path
% addpath('E:\research\codes\MY CODES\Work2\Pixel_profile_plot\plot_points\')
load(Trajname);
k=0;
numFrames=size(TrajectoryCoordinates{1},1);
frames = zeros(numFrames,size(TrajectoryCoordinates,1));

columns = 1:size(TrajectoryCoordinates,1);
% get the common trajectories in a set of frames
% for i=1:numFrames
    for j=1:size(TrajectoryCoordinates,1)
       
        traj(:,1:2) = TrajectoryCoordinates{j};
        traj(:,3) = repmat(j,[size(traj,1) 1]);
        validTraj(:,:,j) = traj;
    
    end
%     overlap(k)=o;
    %subframes(i:i+diff-1,col{k});
% end
 save(validTrajname,'validTraj');
 clear all;
end
