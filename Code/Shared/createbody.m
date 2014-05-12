function body = createbody(left,right, tail)

center = (left+right)/2;
width = 1.2*norm(left-right);
height = norm(center-tail);

tformtype = 'nonreflective similarity';
tform = cp2tform([center;tail],[0,0;0,height], tformtype);


%wid = 120;
%height = 500;
body = [...
    -width/2,0  ;
     width/2,0  ;
     width/2,2/3*height;
     0  ,height;
    -width/2,2/3*height;
    -width/2,0  ];



body = tforminv(tform,body);