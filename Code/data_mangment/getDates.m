function dates = getDates(codes)

dates = cell(size(codes));
for i=1:length(codes)
    record_path = getPath(codes{i});
    photodata = load([record_path filesep 'photodata.mat']);
    dates{i} = photodata.date;
end
