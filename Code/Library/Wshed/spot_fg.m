function [fgm4,fgm] = spot_fg(I, params)

I(230:end,:) = I(230:end,:)*0.9;

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
fgm = im2bw(Iobrcbr, prctile(Iobrcbr(:),params.fgthresh));


fgm = imfill(fgm, 'holes');

%wear back the marks
%se2 = strel(ones(2,2));
se2 = strel('disk', 3);
%fgm = imfill(fgm, 'holes');
fgm2 = imclose(fgm, se2);
se2 = strel('disk', 2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 10);

fgm4 = fgm4|params.fg.pos&~params.fg.neg;

