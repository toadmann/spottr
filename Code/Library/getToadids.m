function toadids = getToadids(codes)

toadids = cell(size(codes));
for i=1:length(codes)
    record_path = getPath(codes{i});
    photodata = load([record_path filesep 'photodata.mat']);
    toadids{i} = photodata.toadid;
end
