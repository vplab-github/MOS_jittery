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
% [~,~,~,L] = superpixels2(img, 500);
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
if i<38
if length(ind1)<length(ind2)
   [y,x] = find(setimage{i}==1);
  foreid=1;backid=2;
else
   [y,x] = find(setimage{i}==2);
   foreid=2;backid=1;
   
end

else
    if length(ind1)<length(ind2)
   [y,x] = find(setimage{i}==1);
  foreid=1;backid=2;
else
   [y,x] = find(setimage{i}==2);
   foreid=2;backid=1;
   
end

end
  Seg=repmat(2,size(setimage{i}));
  setcopy=setimage{i};
  ind1=find(setcopy==foreid);ind2=find(setcopy==backid);
  setcopy(ind1)=1;setcopy(ind2)=2;
%   [y1 x1]=find(setimage{i}==foreid);
if i<30
  Seg(min(y)+0:max(y)-0,min(x)+0:max(x)-0)=setcopy(min(y)+0:max(y)-0,min(x)+0:max(x)-0);
else
  Seg(min(y)+0:max(y)-0,min(x)+0:max(x)-0)=setcopy(min(y)+0:max(y)-0,min(x)+0:max(x)-0);

end
  slicidd=unique(L(Seg==1));
  for jj=1:length(slicidd)
      Seg(L==slicidd(jj))=1;
      
  end

  setimages{i}(find(Seg==1))=1;
    miny = max(1,min(y)-50); minx = max(1,min(x)-50); 
    maxy = min(nr,max(y)+100); maxx = min(nc,max(x)+50);
    Seg(miny:maxy, minx:maxx) = 1;
    
  
    index= find(Seg~=1);
    setimages{i}(index)=0;
%     index= find(Seg==2);
%     setimages{i}(removeindtemp)=2;
imshow(setimages{i}==1);pause(0.1);
end
save(['./Data/' videoFile '/sparsesetimages.mat'], 'setimage','setimages');

end