% loads the base picture
function img = loadBasePicture(code)
record_path = getPath(code);
img = imread([record_path filesep 'base.jpg']);