function deletePicture(code)

record_path = getPath(code);
fprintf('Removing directory %s\n', record_path);
rmdir(record_path,'s');
setappdata(0,'all_codes',getAllCodes());

%now remove all comparisons with this picture too
all_codes = getAllCodes();
for i=1:length(all_codes)
    prog = getDataProgress(all_codes{i});
    record_path = getPath(all_codes{i});
    if prog.compLucas
        compLucas = load([record_path filesep 'compLucas.mat']);
        comps = compLucas.comps;
        codeind = strcmp(code, {comps.code});
        if sum(codeind)
            comps(codeind) = [];
            save([record_path filesep 'compLucas.mat'],'comps');
        end
    end
    
    if prog.compHand
        compHand = load([record_path filesep 'compHand.mat']);
        comps = compHand.comps;
        codeind = strcmp(code, {comps.code});
        if sum(codeind)
            comps(codeind) = [];
            save([record_path filesep 'compHand.mat'],'comps');
        end
    end
end
