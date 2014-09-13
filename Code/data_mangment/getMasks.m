function masks = getMasks(codes)
masks = cell(size(codes));
for i=1:length(codes)
    record_path = getPath(codes{i});
    spotFin = load([record_path filesep 'spotFin.mat']);
    masks{i} = spotFin.fin;
end