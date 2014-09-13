%New organization

opicdir = '~/Toads/Pictures/';
data_path = getappdata(0,'data_path');

for i=1:length(apics)
    pfname = [opicdir apics(i).filename];
    idcode = newRecord(apics(i).set,pfname);
    
    pic = apics(i);
    record_path = [data_path filesep strrep(idcode,'#',filesep)];
    save([record_path filesep 'old_record.mat'], 'pic');
    
end



%%
% 
% How to save marking data
% 	marks.mat
% 	spotRect.mat (color,gray)
% 	spotParams.mat (fg_thresh,edge_sigma,etc,neg,pos)
% 	spotFin.mat
%   quality.mat

allcodes = getAllCodes();
load problems;

for i=1:length(allcodes)
    idcode = allcodes{i};
    record_path = getPath(idcode);
    
    or = load([record_path filesep 'old_record.mat']);
    

    %save quality file
    prob = problems(strcmp({problems.filename},pic.filename));
    quality = [];
    quality.usability = ~prob.usable+1;
    quality.problems.cutoff = prob.cutoff;
    quality.problems.nospots = prob.nospots;
    quality.problems.toadcondition = prob.angle||prob.cold||prob.sandy||prob.bruises||prob.inflated;
    quality.problems.optics = prob.focus||prob.glare||prob.dark;
    quality.problems.other = prob.other;
    save([record_path filesep 'quality.mat'],'-struct','quality');
    
    %now evaluate progress and save other data
    dat = get_wdata(or.pic);
    
    if isempty(dat)
        continue;
    end

    %check if picture has been marked
    if ~isempty(dat.mark.tail)
        %save marks in file
        marks = dat.mark;
        save([record_path filesep 'marks.mat'],'-struct','marks');
        
        %save spot patterns in file
        rect = [];
        rect.color = dat.aligned;
        rect.gray = dat.alignedgray;
        save([record_path filesep 'spotRect.mat'],'-struct','rect');
    end
    
    %check if spot pattern exists
    if (sum(dat.wshed.spots.fin(:))>100)
        %save spot params
        spotParams = [];
        spotParams.fgthresh = dat.wshed.fgthresh;
        spotParams.edge_sigma = dat.wshed.edge_sigma;
        spotParams.pos = dat.wshed.posregion;
        spotParams.neg = dat.wshed.negregion;
        save([record_path filesep 'spotParams.mat'],'-struct','spotParams');
    
        %save final spot pattern
        spotfin = [];
        spotFin.fin = dat.wshed.spots.fin;
        save([record_path filesep 'spotFin.mat'],'-struct','spotFin');
    end
    
    
end

%% do maintnance
%allcodes = getAllCodes();

for i=1:length(allcodes)
    idcode = allcodes{i};
    record_path = getPath(idcode);
    
    or = load([record_path filesep 'old_record.mat']);
    
    use = true;
    lycode = or.pic.filename;
    if (~isempty(strfind(lycode,'Extra photos taken at same time/')))
        use = false;
    end
    
    qual = load([record_path filesep 'quality.mat']);
    if qual.usability>1
        use = false;
    end
    


    photodata = load([record_path filesep 'photodata.mat']);
    photodata.use = use;

    save([record_path filesep 'photodata.mat'],'-struct','photodata');
    
end

%%
setname = '2011 Adults';
thisset = strncmp(ofnames,setname,length(setname));
thiscam = false(size(ofnames));
for i=1:length(ofnames)
    thiscam(i) = ~isempty(regexpi(ofnames{i},'DSC'));
end

other = false(size(ofnames));
for i=1:length(ofnames)
    other(i) = ~isempty(regexpi(ofnames{i},'382'));
end

possible_matches = other&thiscam&thisset;
allcodes(possible_matches)

%%

newcap = [];
newcap.bookoftoadsline = 8;
newcap.set = '2011 Adults';
newcap.toadno = 2010;
newcap.sex = 'M';
newcap.date = '05/28/11';
newcap.time = '10:34';
newcap.piccodes = [185,40];

allcaps = [allcaps newcap];

%%

record_path = getPath('2011 Adults#36');
orig = load([record_path filesep 'original.mat']);
imshow(orig.img);
