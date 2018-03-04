function sets = getSets(codes)
sets = cell(size(codes));
for i=1:length(codes)
    parts = regexp(codes{i},'#','split','once');
    sets{i} = parts{1};
end
