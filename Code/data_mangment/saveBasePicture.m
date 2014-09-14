% saves a picture in the specified record
function saveBasePicture(code, pic)

record_path = getPath(code);

% rescale if pic is big
if numel(pic.img) > (1600*1200*3)
   scale_factor = (1600*1200*3)/numel(pic.img);
   pic.img = imresize(pic.img,scale_factor);
end

imwrite(pic.img,[record_path filesep 'base.jpg']);