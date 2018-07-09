function resultPath = CalcOneSmoothing(camPath,optPath,numFrames,lambda)
resultPath = zeros(1,numFrames);
for i=1:numFrames
    resultPath(i) = camPath(i)*(numFrames^2/(lambda*numFrames+numFrames^2-lambda));
    for j=1:i-1
        resultPath(i) = resultPath(i)+(lambda/(lambda*numFrames+numFrames^2-lambda))*optPath(j);
    end
    for j=i+1:numFrames
        resultPath(i) = resultPath(i)+(lambda/(lambda*numFrames+numFrames^2-lambda))*optPath(j);
    end
end
% % % % % %   updateSet = zeros(3,3,numFrames);
% % % % % %     
% % % % % %     motionSet_Inv = zeros(3,3,numFrames);
% % % % % %     for i=0:numFrames-1
% % % % % %         motionSet_Inv(:,:,i+1) = inv(motionSet(:,:,i+1));
% % % % % %     end
% % % % % %     
% % % % % %     length = num*2+1;
% % % % % %     windowMotions = zeros(3,3,length); %to make it temporal size length and spatial 3
% % % % % %     nbHood = zeros(length,1);
% % % % % % 
% % % % % %     
% % % % % %     
% % % % % % for t=0:numFrames-1
% % % % % %         for k=0:length-1
% % % % % %             windowMotions(:,:,k+1) = eye(3);% for each frame in the windowsize width, initialize identity
% % % % % %             nbHood(k+1) = 0;% initialize 0
% % % % % %         end
% % % % % %         
% % % % % %         k = num-1; 
% % % % % %         for curIdx=t:-1:t-num+1 % no of times to iterate from current frame to the prev frame upto window size
% % % % % %             if curIdx>0
% % % % % %                 windowMotions(:,:,k+1) = windowMotions(:,:,k+1+1) * motionSet(:,:,curIdx+1);%update window motions
% % % % % %                 nbHood(k+1) = 1;% flag to indicate updated % |^motion set is camerapath 
% % % % % %             end
% % % % % %             k = k-1;
% % % % % %         end
% % % % % %         
% % % % % %         k = num+1;
% % % % % %         for curIdx=t+1:t+num
% % % % % %             if curIdx<numFrames
% % % % % %                 windowMotions(:,:,k+1) = windowMotions(:,:,k-1+1)*motionSet_Inv(:,:,curIdx+1);
% % % % % %                 nbHood(k+1) = 1;% for frames more than the half ,multiply with the inverse of the homography ?? 
% % % % % %             end
% % % % % %             k = k+1;
% % % % % %         end
% % % % % %         % window motions are optimized paths
% % % % % %         %% optimized
% % % % % %         sumMotion = zeros(3);
% % % % % %         sumWeight = 0;
% % % % % %         for i=0:length-1
% % % % % %            if nbHood(i+1)
% % % % % %               sumMotion = sumMotion + weights(i+1) .* windowMotions(:,:,i+1);
% % % % % %               sumWeight = sumWeight + weights(i+1);
% % % % % %            end
% % % % % %         end
% % % % % %         sumWeight=sumWeight*2+1;
% % % % % %         
% % % % % %         updateSet(:,:,t+1) = sumMotion ./ sumWeight;
% % % % % %         updateSet(:,:,t+1) = updateSet(:,:,t+1);%+motionSet(:,:,t+1);
% % % % % % end
    
end

