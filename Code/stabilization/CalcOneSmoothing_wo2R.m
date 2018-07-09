function resultPath = CalcOneSmoothing_wo2R(camPath,optPath,numFrames,lambda)
resultPath = zeros(1,size(optPath,2));
R=numFrames/2;
flR = floor(R);
clR = ceil(R);
for i=1:flR
    alpha=(R)/(lambda*R-lambda+R);
    resultPath(2*i) = camPath(2*i)*(alpha);
    resultPath(2*i-1) = camPath(2*i-1)*(alpha);
    for j=1:i-1
        resultPath(2*i) = resultPath(2*i)+(lambda/(R)*alpha)*optPath(2*j);
        resultPath(2*i-1) = resultPath(2*i-1)+(lambda/(R)*alpha)*optPath(2*j-1);
    end
    for j=i+1:flR
        resultPath(2*i) = resultPath(2*i)+(lambda/(R)*alpha)*optPath(2*j);
        resultPath(2*i-1) = resultPath(2*i-1)+(lambda/(R)*alpha)*optPath(2*j-1);
    end
end
if flR~=clR
    for j=1:flR
    resultPath(clR*2-1) = resultPath(2*clR-1)+(lambda/(lambda/(2*R^2)*alpha))*optPath(2*j-1);
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

