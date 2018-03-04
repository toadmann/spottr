% saves the base picture of the toad
%    returns scale factor so that convertOrig2Base can adjust scale of marks
%    that feature can be removed after all pictures are converted
% Alan Schoen, 2014
function scale_factor = saveBasePicture(code, pic)
scale_factor = 1;
record_path = getPath(code);

% rescale if pic is big
if numel(pic.img) > (1600*1200*3)
   scale_factor = (1600*1200*3)/numel(pic.img);
   pic.img = imresize(pic.img,scale_factor);
end

imwrite(pic.img,[record_path filesep 'base.jpg']);