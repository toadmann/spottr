function tform = align_tform(left,right,tail)
body = createbody(left,right,tail);

width = 128;
height = 256;

base_pts = [...
    0.1*width,0.01*height;...
    0.9*width,0.01*height;...
    0.5*width,1.2*height];
input_pts = [...
    body(1,:);
    body(2,:);
    body(4,:)];

tformtype = 'nonreflective similarity';
%tformtype = 'affine';
tform = cp2tform(input_pts,base_pts, tformtype);
