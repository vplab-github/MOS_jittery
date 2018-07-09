function resultSet = CalcOneUpdate1(camPath,optPath,numFrames,lambda1,lambda2,optPathprev,overlap)

  resultSet = CalcOneSmoothing2_wo2R(camPath,optPath,numFrames,lambda1,lambda2,optPathprev,overlap);
  
%   for i=0:numFrames-1
%      resultSet(:,:,i+1) = updateSet(:,:,i+1)*postUpdateSet(:,:,i+1);
%   end
end