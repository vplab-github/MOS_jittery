function [features, labels, labelprobs, weights] = ...
    mcmcGetAllGoodSegments(imsegs, imdir, vclassifierSP, hclassifierSP, ...
    eclassifier, segclassifier, spdata, adjlist, edata, ncv)

for f = 1:numel(imsegs)
    k = mod(ceil(f/(numel(imsegs)/ncv)), ncv) + 1;
    disp([num2str(f) ': ' imsegs(f).imname])
    im = im2double(imread([imdir '/' imsegs(f).imname]));        
    [features{f}, labels{f}, labelprobs{f}, weights{f}] = ...
        mcmcGenerateGoodSegments(im, imsegs(f), vclassifierSP, hclassifierSP, ...
        eclassifier, segclassifier(k), spdata{f}, adjlist{f}, edata{f});
end