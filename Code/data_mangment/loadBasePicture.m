% loads the base picture
% Alan Schoen, 2014
function img = loadBasePicture(code)
record_path = getPath(code);
img = imread([record_path filesep 'base.jpg']);