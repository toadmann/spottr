% searchLimited(primary_codes, database_codes, progress)
% Do a limited search through pictures
% This is the ONLY function that is allowed to use parfor
%
% INPUT
%   primary_codes: list of pictures to search against database
%   database_codes: list of pictures in database to search
%   progress: matrix inidcating which pairs have already been compared
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
data_path = getappdata(0, 'data_path');
primary_masks = getMasks(primary_codes);
results = zeros(1,length(idx));

parfor i=1:length(idx)
    mask1 = primary_masks{idx(i)};
    code2 = database_codes{idy(i)};
    
    corr = compare_maskcode(mask1, code2, data_path)
    
    results(i) = corr;
end

function corr = compare_codecode(code1, code2, data_path)
mask1 = getMaskPar(code1, data_path);
mask2 = getMaskPar(code2, data_path);
[~, ~, corr,~] = jiggle_mask(mask1,mask2);


function corr = compare_maskcode(mask1, code2, data_path)
mask2 = getMaskPar(code2, data_path);
[~, ~, corr,~] = jiggle_mask(mask1,mask2);

