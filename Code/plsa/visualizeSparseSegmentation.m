function visualizeSparseSegmentation(videoFile,C)
load(['./Data/' videoFile '/validTraj.mat']);
img_dir=dir(['./Data/' videoFile '/frames/*.ppm']);
if ~exist(['./Data/' videoFile '/sparseresult/'],'dir')
    mkdir(['./Data/' videoFile '/sparseresult/'])
   
end
folder = ['./Data/' videoFile '/frames/'];
% cd (['./Data/' videoFile '/frames/']);
frames=imread([folder img_dir(1).name]);

for le=1:size(validTraj,2)
    clear coord
    for frameno = 1:size(validTraj{le},1)
% get trajectoryids of the trajectories in M{1}
% IDs = trajids{le};
% get the coordinates of the trajectories in the frames
%frame 1
coord(:,:,frameno) = reshape(validTraj{le}(frameno,1:2,:),size(validTraj{le}(frameno,1:2,:),2),size(validTraj{le}(frameno,1:2,:),3));
end
%     labels = unique(C{i});
%         for m=1:size(labels,1)
%         number(m) = (nnz(C{i}==labels(m)));
%         end
%         sorted = sort(number{i});
%         label_fore=find(number{i}==sorted(1));
%         % get the trajids with this label
%          foretrajids = find(C{i}==label_fore);
%          backtrajids = find(C{i}~=label_fore);
%    %      trajidfore = unique(reshape(validTraj{i}(1,1,foretrajids),size(validTraj{i}(1,1,foretrajids),3),1));
%          
%     for j=blockindex(i):blockindex(i)+size(validTraj{i},1)
%         imshow(imread(img_dir(j).name));
%         hold on;
%       for ke = 1:size(validTraj{i},1)
%        im(max(round(coord(2,i,ke))-1,1):min(round(coord(2,i,ke))+1,size(frames,1)),max(round(coord(1,i,ke))-1,1):min(round(coord(1,i,ke))+1,size(frames,2)),ke) = C{le}(i);
%        im1(max(round(coord(2,i,ke))-1,1):min(round(coord(2,i,ke))+1,size(frames,1)),max(round(coord(1,i,ke))-1,1):min(round(coord(1,i,ke))+1,size(frames,2)),ke) = C{le}(i);
%       end  
%         plot()
%       
%       for ke = 1:size(validTraj{le},1)
%        im(max(round(coord(2,i,ke))-1,1):min(round(coord(2,i,ke))+1,size(frames,1)),max(round(coord(1,i,ke))-1,1):min(round(coord(1,i,ke))+1,size(frames,2)),ke) = C{le}(i);
%        im1(max(round(coord(2,i,ke))-1,1):min(round(coord(2,i,ke))+1,size(frames,1)),max(round(coord(1,i,ke))-1,1):min(round(coord(1,i,ke))+1,size(frames,2)),ke) = C{le}(i);
%       end
% %     end
if le==1 o=0; else o=overlap; end
k=1;
im = zeros(size(frames,1),size(frames,2),size(validTraj{le},1));
im1 = zeros(size(frames,1),size(frames,2),size(validTraj{le},1));
for i=1:size(C{le},1)%size(values,1)
    labels = unique(C{le});
    for m=1:size(labels,1)
    number(m) = (nnz(C{le}==labels(m)));
    end
   sorted = sort(number);
   fore_label=labels(find(number==sorted(1)));
         for ke = 1:size(validTraj{le},1)
       im(max(round(coord(2,i,ke))-1,1):min(round(coord(2,i,ke))+1,size(frames,1)),max(round(coord(1,i,ke))-1,1):min(round(coord(1,i,ke))+1,size(frames,2)),ke) = C{le}(i);
      end
end
seti{le}=im;
end
save(['./Data/' videoFile '/sparse_result.mat'],'C','seti')
sz=0;sz1=0;

for i=1:le
    if i==1 o=0; else o=overlap(i); end
    if i~=1
        sz = size(validTraj{i-1},1)-overlap(i)+sz;
    end

  for frameno=1:size(validTraj{i},1)
     
      sz+frameno ;   
    image = imread([folder img_dir(sz+frameno).name]);
    off = (seti{i}(:,:,frameno)==fore_label);
    k1 = image(:,:,1);
    k1(off) = 255;
    image(:,:,1)=k1;
    k2 = image(:,:,2);
    k2(off) = 0;
    image(:,:,2)=k2;
    k3 = image(:,:,3);
    k3(off) = 0;
    image(:,:,3)=k3;
    
      offt = ((seti{i}(:,:,frameno)~=fore_label)&(seti{i}(:,:,frameno)~=0));
    k1(offt) = 0;
    image(:,:,1)=k1;
    k2(offt) = 0;
    image(:,:,2)=k2;
    k3(offt) = 255;
    image(:,:,3)=k3;  
    
    
    h=figure;imshow(image);
    if sz+frameno>sz1
        setimage{k}=seti{i}(:,:,frameno);k=k+1;
    n = sprintf('%04i',sz+frameno)
    saveas(h,['./Data/' videoFile '/sparseresult/result' num2str(n) '.jpg'])
    end
% pause(0.5);

close all
    end
    sz1=max(sz1,sz+frameno);
end
save(['./Data/' videoFile '/spsparsesetimages.mat'], 'setimage');
end
