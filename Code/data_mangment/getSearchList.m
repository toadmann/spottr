function [searchlist] = getSearchList()
all_codes = getappdata(0,'all_codes');

touse = false(size(all_codes));
for i=1:length(all_codes)
    record_path = getPath(all_codes{i});
    
    pd = load([record_path filesep 'photodata.mat']);
    finexists = exist([record_path filesep 'spotFin.mat'],'file');
    
    touse(i) = pd.use&&finexists;
end

codes = all_codes(touse);
dates = getDates(codes);
sets = getSets(codes);

searchlist = struct('code',codes,'date',dates,'set',sets);


