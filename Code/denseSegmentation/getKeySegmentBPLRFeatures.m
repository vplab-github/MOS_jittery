function [fgFeats bgFeats] = getKeySegmentBPLRFeatures(setimages, bplrdir,numFrames,videoFile)
 names = dir([bplrdir '/BPLR_*']);
folder = ['./Data/' videoFile '/frames/']; 
img_dir=dir([folder '*.ppm']);
im=imread([folder img_dir(1).name]);
rsz = 300/max(size(im)); % resize image such that its longest dimension is 300 pixels.
order_k = 25;
euc_f = 2.5;
min_nseg = 20;
max_nseg = 200;
grid_space = 4;
phog_L = 2;
n_angle_bin = 12;
n_length_bin = 20;
magnif = 1.1;
min_elem_scale = 4; 
i=1;
    
bplr_file = [bplrdir 'BPLR_' sprintf('%04d',i)];
if ~exist([bplr_file '.mat'])
    img_file=[folder img_dir(i).name];
    [BPLR, phog] =...
    demoBPLR([folder 'bplr/'],img_file, rsz, order_k, euc_f, min_nseg, max_nseg, grid_space, min_elem_scale, magnif, phog_L, n_angle_bin, n_length_bin);
save([bplr_file '.mat'], 'BPLR', 'phog')
end

bplr_file = [bplr_file '.mat'];
load(bplr_file, 'phog');
        pb_phog=phog;
fg_pb_phog = zeros(size(pb_phog.feat_vecs,1),10000);
% fg_color_hist = zeros(69,10000);
fg_scales = zeros(1,10000);
fg_locs = zeros(2,10000);
fg_frame_num = zeros(1,10000);

bg_pb_phog = zeros(size(pb_phog.feat_vecs,1),100000);
% bg_color_hist = zeros(69,100000);
bg_scales = zeros(1,100000);
bg_locs = zeros(2,100000);
bg_frame_num = zeros(1,10000);

fgnum = 1;
bgnum = 1;
for i=1:numFrames
    i
    
bplr_file = [bplrdir 'BPLR_' sprintf('%04d',i)];
if ~exist([bplr_file '.mat'])
    img_file=[folder img_dir(i).name];
    [BPLR, phog] =...
    demoBPLR([folder 'bplr/'],img_file, rsz, order_k, euc_f, min_nseg, max_nseg, grid_space, min_elem_scale, magnif, phog_L, n_angle_bin, n_length_bin);
save([bplr_file '.mat'], 'BPLR', 'phog')
end
load([bplr_file '.mat'], 'BPLR', 'phog');%, 'color_hist');
        pb_phog=phog;
        Seg = setimages{i};
        ind = zeros(1,length(BPLR.feats));
        for j=1:length(BPLR.feats)
            ind(j) = Seg(round(pb_phog.feat_centers(2,j)), round(pb_phog.feat_centers(1,j)));
        end
%         color_hist.feat_vecs = reshape(color_hist.feat_vecs,[69 numel(BPLR.feats)]);
        
        fgNdx = find(ind==1);
        if size(fgNdx,2)==0
            fgNdx = find(ind==2);
        end
        numfgfeats = length(fgNdx);         
        fg_pb_phog(:,fgnum:fgnum+numfgfeats-1) = double(pb_phog.feat_vecs(:,fgNdx));
%         fg_color_hist(:,fgnum:fgnum+numfgfeats-1) = double(color_hist.feat_vecs(:,fgNdx));
        fg_scales(:,fgnum:fgnum+numfgfeats-1) = double(pb_phog.feat_scales(fgNdx));        
        fg_locs(:,fgnum:fgnum+numfgfeats-1) = round(double(pb_phog.feat_centers(:,fgNdx)));
        fg_frame_num(:,fgnum:fgnum+numfgfeats-1) = i;
        fgnum = fgnum + numfgfeats;

        bgNdx = find(ind==0);
        numbgfeats = length(bgNdx);         
        bg_pb_phog(:,bgnum:bgnum+numbgfeats-1) = double(pb_phog.feat_vecs(:,bgNdx));
%         bg_color_hist(:,bgnum:bgnum+numbgfeats-1) = double(color_hist.feat_vecs(:,bgNdx));
        bg_scales(:,bgnum:bgnum+numbgfeats-1) = double(pb_phog.feat_scales(bgNdx));        
        bg_locs(:,bgnum:bgnum+numbgfeats-1) = round(double(pb_phog.feat_centers(:,bgNdx)));
        bg_frame_num(:,bgnum:bgnum+numbgfeats) = i;
        bgnum = bgnum + numbgfeats;
end

fgFeats.pb_phog = fg_pb_phog(:,1:fgnum-1);
% fgFeats.color_hist = fg_color_hist(:,1:fgnum-1);
fgFeats.scales = fg_scales(:,1:fgnum-1);
fgFeats.locs = fg_locs(:,1:fgnum-1);
fgFeats.frame_num = fg_frame_num(:,1:fgnum-1);

bgFeats.pb_phog = bg_pb_phog(:,1:bgnum-1);
% bgFeats.color_hist = bg_color_hist(:,1:bgnum-1);
bgFeats.scales = bg_scales(:,1:bgnum-1);
bgFeats.locs = bg_locs(:,1:bgnum-1);
bgFeats.frame_num = bg_frame_num(:,1:bgnum-1);
