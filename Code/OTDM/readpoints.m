%% read the points from dat file(tracks)
function [numFrames] = readpoints(folder,fileLocation,name)
% A=importdata(fileLocation);
    d = fopen([folder fileLocation]);
    numFrames = str2double(fgetl(d));
    noOfTrajectories = str2double(fgetl(d));
  TrajectoryCoordinates=cell(noOfTrajectories,1);
 for i=1:noOfTrajectories
    tline = fgetl(d);
    a = strread(tline);
    noOfFramesForTraj(i)= a(2);
    TrajectoryCoordinates{i}=zeros(numFrames,2);
    for j=1:noOfFramesForTraj(i)
        coordFrames = strread(fgetl(d));
    % jth frame
        TrajectoryCoordinates{i}(coordFrames(3)+1,:) = [max(abs(coordFrames(1)),1) max(abs(coordFrames(2)),1)];
   
    end
 end
 save([folder name],'TrajectoryCoordinates','numFrames');
end
 