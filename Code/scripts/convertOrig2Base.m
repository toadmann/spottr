% Convert all "original.mat" files to "base.jpg"
% This saves a LOT of disk space
%
% I did not do ANY error checking so this will crash under a lot of
% circumstances
%
% I made it a function instead of a script so I could include the
% loadPicture function
%
% Alan Schoen, 2014
function convertOrig2Base(codes)

% Create base.jpg
for i=1:length(codes)
   imcode = codes{i};
   imstruct = loadPicture(imcode);
   scale = saveBasePicture(imcode, imstruct);
   if scale<1
      scaleMarks(imcode, scale);
   end
end

% Remove original.mat
for i=1:length(codes)
   imcode = codes{i};
   record_path = getPath(imcode);
   orig_path = [record_path filesep 'original.mat'];
   delete(orig_path);
end

function orig = loadPicture(code)
record_path = getPath(code);
orig = load([record_path filesep 'original.mat']);
