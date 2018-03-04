function data = init_data()
%Event info
data.user = '';
data.time = [];

%Alignment marks
data.mark.left = [];
data.mark.right = [];
data.mark.tail = [];

%Aligned image
data.aligned = zeros(256,128,3);
data.alignedgray = zeros(256,128);

%Watershed stuff
data.wshed.do = true;
data.wshed.fg.raw = false(256,128);
data.wshed.fg.neg = false(256,128);
data.wshed.fg.pos = false(256,128);
data.wshed.fg.fin = false(256,128);

data.wshed.edges.raw = false(256,128);
data.wshed.edges.neg = false(256,128);
data.wshed.edges.pos = false(256,128);
data.wshed.edges.fin = false(256,128);

data.wshed.spots.raw = false(256,128);
data.wshed.spots.neg = false(256,128);
data.wshed.spots.pos = false(256,128);
data.wshed.spots.fin = false(256,128);

data.wshed.posregion = cell(1,0);
data.wshed.negregion = cell(1,0);
data.wshed.fgthresh = 90;
data.wshed.edge_sigma = 2;