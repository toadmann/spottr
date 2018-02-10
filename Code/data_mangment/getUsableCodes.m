function [codes] = getUsableCodes(codes)
% all_codes = getappdata(0,'all_codes');
touse = false(size(codes));
for i=1:length(codes)
    record_path = getPath(codes{i});
    
    pd = load([record_path filesep 'photodata.mat']);
    finexists = exist([record_path filesep 'spotFin.mat'],'file');
    
    touse(i) = pd.use&&finexists;
end

codes = codes(touse);
