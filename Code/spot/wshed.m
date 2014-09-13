function [mask] = wshed(img)
I = rgb2gray(img);
I = imcomplement(I);
I = I - imfilter(I,fspecial('average',[64 32]),'replicate');
I = (I-min(I(:)))/range(I(:));

%compute edges
hy = fspecial('sobel');
hx = hy';
It = imfilter(I,fspecial('gaussian',13,4),'replicate');
Iy = imfilter(double(It), hy, 'replicate');
Ix = imfilter(double(It), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

%MARK FOREGROUND
se = strel('disk', 2);
%opening by reconstruction
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

%something else
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

%get regional maxima
%fgm = imregionalmax(Iobrcbr);
%fgm = imextendedmax(Iobrcbr, 0.1);
fgm = im2bw(Iobrcbr, prctile(Iobrcbr(:),85));
%fgm = im2bw(Iobrcbr, graythresh(Iobrcbr));

fgm = imfill(fgm, 'holes');

%wear back the marks
%se2 = strel(ones(2,2));
se2 = strel('disk', 3);
%fgm = imfill(fgm, 'holes');
fgm2 = imclose(fgm, se2);
se2 = strel('disk', 2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 10);

% Mark background

%bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
bw = im2bw(Iobrcbr, prctile(Iobrcbr(:),65));

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

% Watershed

%force connectivity of foreground regions
%gradmag(imdilate(edge(fgm4), ones(2,2))) = max(gradmag(:));

%restrict regional maxima to background and foreground
gradmag2 = imimposemin(gradmag, bgm | fgm4);
%gradmag2 = imimposemin(gradmag, fgm4);

L = watershed(gradmag2);

%pick out the good ones
labs = unique(L);
mask = false(size(I));
for lno = 1:length(labs)
    
    bin = (L==labs(lno));
    [Y,X] = find(bin);
    if (max(Y)<236) &&(min(Y)>5)&& (sum(bin(:))<1200)
        mask = mask|bin;
    end
end

%mask = mask|fgm4;

cc = bwconncomp(fgm4);
blobs = cc.PixelIdxList;
for i=1:length(blobs)
    blob = blobs{i};
    bin = false(size(mask));
    bin(blob) = true;
    
    [Y,X] = ind2sub(size(I), blob);
    
    if (max(Y)<236) &&(min(Y)>5)&& (sum(bin(:))<1200)
        mask = mask|bin;
    end
end
