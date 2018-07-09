function resultPath = CalcOneSmoothing1(camPath,optPath,numFrames,lambda1,lambda2,optPathprev,overlap)
resultPath = zeros(1,numFrames);
L(1:overlap)=1;
L(overlap+1:numFrames)=0;
R = size(optPath,2);
for i=1:numFrames
    den = (lambda1*numFrames+numFrames^(2)-lambda1+numFrames^2*lambda2*L(i));
     resultPath(i) = camPath(i)*(numFrames^2/den);
    for j=1:i-1
        resultPath(i) = resultPath(i)+(lambda1/den)*optPath(j);
    end
    for j=i+1:numFrames
       
        resultPath(i) = resultPath(i)+(lambda1/den)*optPath(j);
    end
    if L(i)==1
        
    resultPath(i) = resultPath(i)+lambda2*optPathprev(numFrames-overlap+i);
    end
end
% resultPath = zeros(1,numFrames);
% for i=1:numFrames
%     den = (lambda1*numFrames+numFrames^2-lambda1)%+lambda2*L(i)*numFrames^2);
%   resultPath(i) = camPath(i)*(numFrames^2/den);
% %       resultPath(i) = resultPath(i)+((lambda2*L(i)*(numFrames^2))/den)*optPathprev(diff-overlap+i);
%   for j=1:i-1
%         resultPath(i) = resultPath(i)+(lambda1/den)*optPath(j);
%     end
%     for j=i+1:diff
%         resultPath(i) = resultPath(i)+(lambda1/den)*optPath(j);
%     end
% end

end

