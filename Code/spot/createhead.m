function head = createhead(left, right)

%d1 = right-center;
%angle = atan2(d1(2),d1(1));
%
%
%rotation = [...
%    cos(angle),-sin(angle),0 ...
%    sin(angle), cos(angle),0 ...
%    0         , 0         ,1];

tformtype = 'nonreflective similarity';
tform = cp2tform([left;right],[-110,0;110,0], tformtype);

load head;

body = [...
    -110,0  ;
     110,0  ;
     110,300;
     0  ,500;
    -110,300];



head = tforminv(tform,head);