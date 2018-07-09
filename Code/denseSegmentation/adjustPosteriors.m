function [fgpim,bgpim,bgind] = adjustPosteriors(setimages,nr,nc,imname,fgpim,bgpim)

Seg=setimages{imname};
[y,x] = find(Seg==1);
miny = max(1,min(y)-50); minx = max(1,min(x)-50); 
maxy = min(nr,max(y)+50); maxx = min(nc,max(x)+50);
Seg(miny:maxy, minx:maxx) = 1;
bgind = find(Seg==0);

bgpim(bgind) = 1;
fgpim(bgind) = 0;
