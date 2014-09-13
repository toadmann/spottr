function [I] = spot_I(img, params)

if sum(params.fg.pos(:))<20
    I = rgb2gray(img);
    I = imcomplement(I);
    I = I - imfilter(I,fspecial('average',[64 32]),'replicate');
    I = (I-min(I(:)))/range(I(:));
else
    %put image in spot space
    img = img - imfilter(img,fspecial('average',[64 32]),'replicate');
    collist = reshape(img, [size(img,1)*size(img,2) 3]);
    spotcol = mean(collist(find(params.fg.pos),:),1);
    bgcol = mean(collist(find(~params.fg.pos),:),1);
    sz = [size(img,1), size(img,2)];
    colimg = @(x, sz)cat(3,x(1)*ones(sz), x(2)*ones(sz), x(3)*ones(sz));
    img = img - colimg(bgcol,sz);
    img = img.*(colimg(spotcol-bgcol,sz));
    I = sum(img,3);
    %I = I - imfilter(I,fspecial('average',[64 32]),'replicate');
    I = (I-min(I(:)))/range(I(:));
end