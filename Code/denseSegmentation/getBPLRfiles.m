function getBPLRfiles(videoFile)
addpath(genpath('.'));
folder = ['./Data/' videoFile '/frames/'];
imgdir=dir([folder '*.ppm']);
if ~exist([folder 'bplr/'],'dir')
    mkdir([folder 'bplr/']);
end
for i=1:size(imgdir,1)
    i
img_file = [folder imgdir(i).name];
im = imread(img_file);
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
[BPLR, phog] =...
    demoBPLR([folder 'bplr/'],img_file, rsz, order_k, euc_f, min_nseg, max_nseg, grid_space, min_elem_scale, magnif, phog_L, n_angle_bin, n_length_bin);
s=sprintf('%04d',i);
save([folder 'bplr/BPLR_' s '.mat'],'BPLR','phog');
end
end