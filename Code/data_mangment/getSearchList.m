function [searchlist] = getSearchList()
all_codes = getappdata(0,'all_codes');

touse = false(size(all_codes));
for i=1:length(all_codes)
    record_path = getPath(all_codes{i});
    
    pd = load(fullfile(record_path, 'photodata.mat'));
    finexists = exist(fullfile(record_path, 'spotFin.mat'),'file');
    
    touse(i) = pd.use&&finexists;
end

codes = all_codes(touse);
dates = getDates(codes);
sets = getSets(codes);

searchlist = struct('code',codes,'date',dates,'set',sets);


