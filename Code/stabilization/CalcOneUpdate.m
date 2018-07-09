function resultSet = CalcOneUpdate(camPath,optPath,numFrames,lambda)

  resultSet = CalcOneSmoothing_wo2R(camPath,optPath,numFrames,lambda);
  
%   for i=0:numFrames-1
%      resultSet(:,:,i+1) = updateSet(:,:,i+1)*postUpdateSet(:,:,i+1);
%   end
end