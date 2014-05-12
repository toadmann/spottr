function codes = getCodes(setname)
data_path = getappdata(0,'data_path');

contents = dir([data_path filesep setname]);

codes = {};
for i=1:length(contents)
    num = str2double(contents(i).name);
    if contents(i).isdir&&~isnan(num)
        codes = cat(2,codes,[setname '#' contents(i).name]);
    end
end