%scriptConvertComparisons

load comparisons;
%comparisons.pics
%comparisons.hand.done
%compairons.hand.match
%comparisons.id.confirmed
%comparisons.id.match
%comparisons.hand.done
%comparisons.hand.match

allcodes = getappdata(0,'all_codes');
fnames = cell(size(allcodes));
for i=1:length(allcodes)
    record_path = getPath(allcodes{i});
    or = load([record_path filesep 'old_record.mat']);
    fnames{i} = or.pic.filename;
end

compcodes = cell(size(comparisons.pics));
for i=1:length(comparisons.pics)
    thispic = strcmp(comparisons.pics(i).filename,fnames);
    if sum(thispic)>1
        error('dudeplicate');
    end
    compcodes{i} = allcodes{thispic};
end


for i=1:length(comparisons.pics)
    record_path = getPath(compcodes{i});
    
    %save lucas comparison file
    doneones = comparisons.lucas.done(i,:);
    comps = struct('code',compcodes(doneones),'value',num2cell(comparisons.lucas.corr(i,doneones)));
    save([record_path filesep 'compLucas.mat'],'comps');
    
    %save hand comparison file
    doneones = comparisons.hand.done(i,:);
    comps = struct('code',compcodes(doneones),'value',num2cell(comparisons.hand.match(i,doneones)));
    save([record_path filesep 'compHand.mat'],'comps');
end

%comps.lucas
%comps.hand

%comp.code
%comp.value