function [gradmag,raw] = spot_edges(I,params)
if nargin<2
    force = false;
end

%compute edges
hy = fspecial('sobel');
hx = hy';
It = imfilter(I,fspecial('gaussian',ceil(3*params.edge_sigma)+1,params.edge_sigma),'replicate');
Iy = imfilter(double(It), hy, 'replicate');
Ix = imfilter(double(It), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2)/5;

raw = gradmag;
gradmag(params.edges.pos) = max(gradmag(:));
gradmag(params.edges.neg) = 0.0;
