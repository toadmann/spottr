function [corrs,progress] = searchLimited(primary_codes, database_codes, progress)

if nargin<3
    progress = false(length(primary_codes),length(database_codes));
end

corrs = zeros(length(primary_codes),length(database_codes));

wbh = waitbar(0,'Prince charming is hard at work','CreateCancelBtn',@cancel_search,'WindowStyle','modal');
ncomps = sum(~progress(:));
setappdata(wbh,'canceling',false);

while (sum(~progress(:)))
    if getappdata(wbh,'canceling')
        break;
    end
    [idx,idy] = find(~progress,200,'first');
    inds = sub2ind(size(progress),idx,idy);
    results = preload_and_compute_parallel(primary_codes, database_codes, idx, idy);
    progress(inds) = true;
    corrs(inds) = results;
    waitbar(sum(progress(:))/ncomps);
end
if ishandle(wbh)
    delete(wbh);
end

function cancel_search(hObject,eventdata,handles)
fh = gcbf;
setappdata(fh,'canceling',true);
%delete(fh);

function results = preload_and_compute_parallel(primary_codes, database_codes, idx, idy)

primary_masks = getMasks(primary_codes);


results = zeros(1,length(idx));

parfor i=1:length(idx)
    mask1 = primary_masks{idx(i)};
    code2 = database_codes{idy(i)};
    
    corr = compare_maskcode(mask1,code2)
    
    results(i) = corr;
end

function corr = compare_codecode(code1,code2)
mask1 = getMask(code1);
mask2 = getMask(code2);
[~, ~, corr,~] = jiggle_mask(mask1,mask2);


function corr = compare_maskcode(mask1,code2)
mask2 = getMask(code2);
[~, ~, corr,~] = jiggle_mask(mask1,mask2);
