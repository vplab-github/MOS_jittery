function [mark]=get_connected_labelling(cut,offset)
% get connected components
mark = zeros(size(cut,1),size(cut,2));
CC = bwconncomp(cut);
% any component no less than a threshold add
for i=1:CC.NumObjects
sz=size(CC.PixelIdxList{1,i});
if sz<500
mark(CC.PixelIdxList{1,i})=1;
end
offset1=zeros(max(size(CC.PixelIdxList{1,i},1),size(offset,1)),1);
offset1(1:size(offset,1))=offset;
endmark=0;
for j=1:size(offset)
val=any(offset1(j)==CC.PixelIdxList{1,i});
if val==1
    endmark=1;
end
end
if endmark==1
    mark(CC.PixelIdxList{1,i})=1;
end
end
%in each the connected component, check any offset present
%if yess add to cut
% mark = zeros(size(cut,1),size(cut,2));
% q = Queue;
% for i =1:size(offset,1)
%     % mark the elements and enq
% q.enqueue(offset(i,:));
% mark(offset(i,1),offset(i,2))=1;
% end
% while ~(isempty(q))
%    element = q.dequeue;
%    % get neighbor coordinates
%    neighbors_coord1 = [element.data(1)-1:element.data(1)+1;element.data(2)-1:element.data(2)+1];
%    n1=neighbors_coord1(1,:);
%    n2=neighbors_coord1(2,:);
%    offset1=neighbors_coord1(1,:)<=size(cut,1);
%    offset2=neighbors_coord1(2,:)<size(cut,2);
%    n1_new=n1(offset1);
%    n2_new=n2(offset2);
%    neighbors_coord{1} = n1_new;
%    neighbors_coord{2} = n2_new;
%    cut_neighbors =cut(n1_new,n2_new);
%    mark_neighbors = mark(n1_new,n2_new);
%    % check if in cut is zero or it is marked 
%    [row,col] = find(cut_neighbors==1 & mark_neighbors==0);
%    clear to_enqueue;
%    if size(row,1)~=0
%    to_enqueue(:,1) = n1_new(row);
%    to_enqueue(:,2) = n2_new(col);
%    % if yes mark ad enqueue it
%    for i =1:size(to_enqueue,1)
%     % mark the elements and enq
%     q.enqueue(to_enqueue(i,:));
%     mark(to_enqueue(i,1),to_enqueue(i,2))=1;
%    end
%    end
% end
end