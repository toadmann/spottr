function [cc,mask1] = mask_affine(mask1,mask2,params)

tformmat = reshape([params 1],[3 3]);
tform = maketform('projective',tformmat);
mask1 = imtransform(mask1, tform,'FillValues',0,'Size',size(mask1));

cc = corrcoef(double(mask1(:)),double(mask2(:)));
cc = -cc(2);
