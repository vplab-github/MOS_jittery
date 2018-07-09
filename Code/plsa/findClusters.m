function [C]=findClusters(videoFile,sigma,p)
load(['./Data/' videoFile '/OTDM_OPTOTDM.mat']);
load(['./Data/' videoFile '/validTraj.mat']);
kk=1;
for le=1:size(validTraj,2)
    
    % for each block do plsa clustering
     normmat = OPTOTDM{le};
    norm_col = diag(normmat'*normmat)';
    normmat= normmat./repmat(norm_col,size(normmat,1),1);
    clear norm_col;
   [U S V] = svd(normmat);
   Ut = U(:,1:p);
   St = S(1:p,:);
   W0 = abs(Ut);H0 = abs(St*V');
% [H,W] = nmf_admm(normmat,W0,H0,1,10,500);
[H,W,~,~] = nmf_kl(normmat,p);

clear coord;clear affMat;
for frameno = 1:size(validTraj{le},1)

coord(:,:,frameno) = reshape(validTraj{le}(frameno,1:2,:),size(validTraj{le}(frameno,1:2,:),2),size(validTraj{le}(frameno,1:2,:),3));
end
%% sigma calculation
% for i=1:size(W,2)-1
%     difference_min(i) = min(sum((repmat(W(:,i),1,size(W,2)-1)-[W(:,1:i-1) W(:,i+1:end)]),1)/size(W,1));
% end
% sigma=min(difference_min);

for i=1:size(W,2)
%     i
    for j=1:size(W,2)
        affMat(i,j) = exp(-norm(W(:,i)-W(:,j),2)/sigma);
    end
end

%% spectral clustering
flag=1;
while flag==1
[C1,C{le},L,U,flag] = SpectralClustering1(affMat,2,2);
end
% id=kmeans(affMat,2);
clear affMat;
p=p+1;
sigma=sigma-0.000075
end

end