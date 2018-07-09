function StabilizeTraj(videoFile,lambda1,lambda2)
load(['./Data/' videoFile '/validTraj.mat']);
iterations=20;
limit=size(validTraj,2);
for l=1:limit
   l
     OTDM{l} = zeros(2*size(validTraj{l},1),size(validTraj{l},3));
     clear x1;clear y1;clear mag;clear cosi;clear sini;
   TrajIDs = trajids{l};
    clear seti; seti=[];
    m=1;
    clear optPathx;clear optPathy;clear x1;clear y1;clear origx1;clear origy1;clear origoptPathx;clear origoptPathy;
for i=1:size(validTraj{l},3)

        TrajCoord = validTraj{l}(:,:,i);
        tempx=TrajCoord(:,1);
        tempy=TrajCoord(:,2);
        origx1(i,:)=TrajCoord(:,1);
        origy1(i,:)=TrajCoord(:,2);
        origoptPathx(i,:)=origx1(i,:);
        origoptPathy(i,:)=origy1(i,:); 

        %% ignore trajectories stagnant
        in = find(diff(tempx)==0);
        gradtx=diff(tempx);
        gradtx(in) = 0.0001;
        clear in;
         in = find(diff(tempy)==0);
        gradty=diff(tempy);
        gradty(in) = 0.0001;
%         tempx(in)=[];tempy(in)=[];
        x1(i,:) = zeros(1,size(tempx,1));
        y1(i,:) = zeros(1,size(tempx,1));
        x1(i,2:end) = gradtx;%diff(tempx);
        y1(i,2:end) = gradty;%diff(tempy); 
         if nnz(gradtx)~=0
        x1(i,1) = x1(i,2);
       end
       if nnz(gradtx)~=0
        y1(i,1) = y1(i,2);
       end
        mag(i,:) = sqrt(x1(i,:).^2+y1(i,:).^2)';
    cosi(i,:) = (x1(i,:))./mag(i,:);
    sini(i,:) = (y1(i,:))./mag(i,:);
     OTDM{l}(2:2:2*size(mag(i,:),2),i) = mag(i,:).*(sini(i,:)+1);
     OTDM{l}(1:2:2*size(mag(i,:),2)-1,i) = mag(i,:).*(cosi(i,:)+1);
%      OTDM{l}(2:2:2*size(mag(i,:),2),i) = tempx;%mag(i,:).*(sini(i,:)+1);
%      OTDM{l}(1:2:2*size(mag(i,:),2)-1,i) = tempy;%mag(i,:).*(cosi(i,:)+1);
optPathx(i,:) = OTDM{l}(:,i);
diffe = size(optPathx,2);
if l==1
    
    seti = 1:size(validTraj{l},3);
for k=1:iterations
   optPathx(i,:) = CalcOneUpdate(OTDM{l}(:,i),optPathx(i,:),diffe,lambda1);

end
else
  
   ind = find(prevTrajID==TrajIDs(i));
    if nnz(ind)~=0
        seti = [seti i];
        for k=1:iterations
           optPathx(i,:) = CalcOneUpdate1(OTDM{l}(:,i),optPathx(i,:),diffe,lambda1,lambda2,optPrevx(ind,:),overlap(l));
  %          optPathy(i,:) = CalcOneUpdate1(M{l}(size(mag(i,:),2)+1:2*size(mag(i,:),2),i),optPathy(i,:),diffe,lambda1,lambda2,optPrevy(ind,:),overlap);
     
        end
    end
end
OPTOTDM{l}(:,m) = optPathx(i,:)';
m=m+1;
origoptPathx(i,1) = origx1(i,1);
origoptPathy(i,1) = origy1(i,1);
opy=optPathx(i,2:2:2*size(mag(i,:),2));
opx=optPathx(i,1:2:2*size(mag(i,:)-1,2));
for numele =2:size(origx1,2)
origoptPathx(i,numele) = opx(numele)+origoptPathx(i,numele-1);
origoptPathy(i,numele) = opy(numele)+origoptPathy(i,numele-1);
end
end
prevx1 = x1;
prevy1 = y1;
optPrevx = optPathx;
% optPrevy = optPathy;
prevTrajID = TrajIDs;
end
save(['./Data/' videoFile '/OTDM_OPTOTDM.mat'],'OTDM','OPTOTDM');

end