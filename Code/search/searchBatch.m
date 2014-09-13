function searchBatch(codes, nyears)
for i=1:length(codes)
    failsafeMark(codes{i});
end

if nargin<2
    nyears = 2;
end

dates = getDates(codes);

years = zeros(size(codes));
for i=1:length(codes)
    years(i) = dates{i}(1);
end
minyear = min(years);
maxyear = max(years);

[all_searchable] = getSearchList();

%restrict to photos within range of years
years = zeros(size(all_searchable));
for i=1:length(all_searchable)
    years(i) = all_searchable(i).date(1);
end
touse = (maxyear>=years)&((minyear-years)<nyears);
to_search = {all_searchable(touse).code};

done_before = false(length(codes),length(to_search));

%mark comparisons that have already been made
for i=1:length(codes)
    record_path = getPath(codes{i});
    prog = getDataProgress(codes{i});
    
    if ~prog.compLucas
        continue;
    end
    
    compLucas = load([record_path filesep 'compLucas.mat']);
    luccodes = {compLucas.comps.code};
    
    
    already_done = ismember(to_search,luccodes);
    
    done_before(i,already_done) = true;
    
end

[corrs, done_now] = searchLimited(codes, to_search, done_before);

newly_done = done_now&~done_before;

%now add new codes to comparison file
for i=1:length(codes)
    
    if ~any(newly_done(i,:))
        continue;
    end
    
    record_path = getPath(codes{i});
    
    if exist([record_path filesep 'compLucas.mat'],'file')
        compLucas = load([record_path filesep 'compLucas.mat']);
        comps = compLucas.comps;
    else
        comps = struct('code',cell(1,0),'value',cell(1,0));
    end
    
    codes_to_add = to_search(newly_done(i,:));
    corrs_to_add = num2cell(corrs(i,newly_done(i,:)));
    
    newcomps = struct('code',codes_to_add,'value',corrs_to_add);
    
    comps = cat(2,comps, newcomps);
    
    save([record_path filesep 'compLucas.mat'],'comps');
end
