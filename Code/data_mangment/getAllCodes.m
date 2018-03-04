function allcodes = getAllCodes
data_path = getappdata(0,'data_path');
contents = dir(data_path);
contents(1:2) = [];

contents = contents([contents.isdir]);
setnames = {contents.name};

allcodes = {};
for i=1:length(setnames)
    allcodes = cat(2,allcodes,getCodes(setnames{i}));
end