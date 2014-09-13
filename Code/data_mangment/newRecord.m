function idcode = newRecord(setname, filename)
data_path = getappdata(0,'data_path');
if ~exist([data_path filesep setname],'dir')
    mkdir(data_path,setname);
end
set_path = [data_path filesep setname];
idnum = next_id(set_path);
mkdir(set_path,num2str(idnum));
record_path = [set_path filesep num2str(idnum)];
img = imread(filename);
tstamp = [];
iminf = imfinfo(filename);
if isfield(iminf,'DigitalCamera')
    picturedate = iminf.DigitalCamera.DateTimeOriginal;
    tstamp = regexp(picturedate,'^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})', 'tokens','once');
    tstamp = str2double(tstamp);   
end
idcode = [setname '#' num2str(idnum)];
save([record_path filesep 'original.mat'], 'img', 'tstamp');

function num = next_id(dname)
contents = dir(dname);
maxpic = 0;
for i=1:length(contents)
    num = str2double(contents(i).name);
    if contents(i).isdir&&~isempty(num)
        maxpic = max(maxpic, num);
    end
end
num = maxpic+1;