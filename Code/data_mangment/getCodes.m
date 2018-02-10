function codes = getCodes(setname)
data_path = getappdata(0,'data_path');

contents = dir(fullfile(data_path, setname));
contents = contents(cellfun(@(s) ~startsWith(s, '.'), {contents.name}));
codes = cellfun(@(n) [setname '#' n], {contents.name}, 'UniformOutput', false);