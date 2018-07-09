function ObjectProposal(videoFile)
% read setimages
load(['./Data/' videoFile '/spsparsesetimages.mat']);
img_dir=dir(['./Data/' videoFile '/frames/*.ppm']);
% setimages=setimage;
for i=1:size(setimage,2)
    i
% get the  foreground and background coordinates
% get slic of fg and bg name as 1 and 0 give the rest as 2
im=imread(['./Data/' videoFile '/frames/' img_dir(i).name]);
[nr,nc,~]=size(im);
setimages{i}=repmat(2,size(setimage{i}));
   [L,~] = superpixels(im,500);
ind1=find(setimage{i}==1);
ind2=find(setimage{i}==2);
indtemp1=[];indtemp2=[];
 slicid = unique(L(ind1));
for j=1:length(slicid)
   
    tempind=find(L==slicid(j));
    indtemp1=[indtemp1;tempind];
end


  slicid = unique(L(ind2));
for j=1:length(slicid)
   
    tempind=find(L==slicid(j));
    indtemp2=[indtemp2;tempind];
end
if length(ind1)>length(ind2)
   [y,x] = find(setimage{i}==1);
    setimages{i}(indtemp1)=1;
    setimages{i}(indtemp2)=0;
else
   [y,x] = find(setimage{i}==2);
    setimages{i}(indtemp2)=1;
    setimages{i}(indtemp1)=0;

end
 
 Seg=zeros(size(setimage{i}));
    miny = max(1,min(y)-50); minx = max(1,min(x)-50); 
    maxy = min(nr,max(y)+100); maxx = min(nc,max(x)+50);
    Seg(miny:maxy, minx:maxx) = 1;
%     removeind=[];
%     Seg(miny:min(y)+10, minx:maxx) = 2;removeind=[removeind;unique(L(miny:min(y)+10, minx:maxx))];
%      Seg(miny:maxy, minx:min(x)+10) = 2;removeind=[removeind;unique(L(miny:maxy, minx:min(x)+10))];
%      Seg(miny:maxy, min(max(x)-10,1):maxx) = 2;removeind=[removeind;unique(L(miny:maxy, max(x)-10:maxx))];
%     removeindtemp=[];
%      for j=1:length(removeind)
%    
%     tempind=find(L==removeind(j));
%     removeindtemp=[removeindtemp;tempind];
%      end
% 
    index= find(Seg~=1);
    setimages{i}(index)=0;
%     index= find(Seg==2);
%     setimages{i}(removeindtemp)=2;
imshow(setimages{i}==1);pause(0.1);
end
save(['./Data/' videoFile '/sparsesetimages.mat'], 'setimage','setimages');

end