
img_dir=dir('./Data/shot1/objectproposal/*.png');

for i=1:size(img_dir,1)
    im=imread(['./Data/shot1/objectproposal/' img_dir(i).name]);
    [nr,nc,~]=size(im);
    setimages{i}=repmat(0,size(im,1),size(im,2));
    setimages{i}((im(:,:,2)>10))=1;
    imshow(setimages{i}==1)
%     [y x]=find(setimages{i}==1);
%        miny = max(1,min(y)-10); minx = max(1,min(x)-10); 
%     maxy = min(nr,max(y)+100); maxx = min(nc,max(x)+10);
%     setimages{i}(miny:maxy, minx:maxx) = 0;
end
setimage=setimages;
save(['./Data/shot1/sparsesetimages.mat'], 'setimage', 'setimages');

