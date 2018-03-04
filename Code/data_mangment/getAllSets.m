function allsets = getAllSets
data_path = getappdata(0,'data_path');
contents = dir(data_path);
contents(1:2) = [];

contents = contents([contents.isdir]);
allsets = {contents.name};
