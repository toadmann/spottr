function newcode = movePicture(code, newset)
parts = regexp(code, '#','split','once');
oldset = parts(1);
if strcmp(oldset,newset)
    return;
end


[num,set_path2] = next_id(newset);
mkdir(set_path2,num2str(num));
movefile([getPath(code) filesep '*'],[set_path2 filesep num2str(num)]);
rmdir(getPath(code));

newcode = [newset '#' num2str(num)];

function [num, set_path] = next_id(setname)
data_path = getappdata(0,'data_path');
set_path = [data_path filesep setname];
contents = dir(set_path);
maxpic = 0;
for i=1:length(contents)
    num = str2double(contents(i).name);
    if contents(i).isdir&&~isempty(num)
        maxpic = max(maxpic, num);
    end
end
num = maxpic+1;
