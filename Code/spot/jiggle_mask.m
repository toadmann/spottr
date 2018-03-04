% [mask1luc, plain, luc,p] = jiggle_mask(mask1,mask2)
% Jiggles mask1 to match mask2
% This is the core of the matching algorithm
function [mask1luc, plain, luc,p] = jiggle_mask(mask1,mask2)

cc = corrcoef(double(mask1(:)),double(mask2(:)));
plain = cc(2);

options = [];
options.TranslationIterations = 6;
options.AffineIterations = 8;
options.TolP = 5e-3;
options.RoughSigma = 10;
options.FineSigma = 3;
options.SigmaIterations = 4;

[p,mask1luc,~]=LucasKanadeInverseAffine(double(mask1),[0 0 0 0 128 64],double(mask2), ones(size(mask2)),options);
cc = corrcoef(double(mask1luc(:)),double(mask2(:)));
luc = cc(2);