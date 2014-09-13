% pic_description(pics,comparisons)
% generates descriptions of pictures for display in UI
function varargout = pic_description(pics,comparisons)
if nargin>1
    iscomp = true;
else
    iscomp = false;
end

if length(pics)<1
    varargout = {'',''};
    return;
elseif length(pics) == 1
    ismulti = false;
else
    ismulti = true;
end
%get output
if ~(iscomp||ismulti)
    varargout = {single_p1(pics)};
elseif iscomp&&~ismulti
    varargout = {single_p1(pics),single_p2(pics,comparisons)};
elseif (~iscomp)&&ismulti
    varargout = {multi_p1(pics)};
elseif iscomp&&ismulti
    varargout = {multi_p1(pics),multi_p2(pics,comparisons)};
end

function text = single_p1(pic)
text = sprintf('Capture Date: %s\n',datestr(pic.date,'mm/dd/yyyy'));
text = [text sprintf('ID: %d\n',pic.ID)];
text = [text sprintf('Sex: %s\n',pic.sex)];
text = [text sprintf('Data set: %s\n',pic.set)];

function text = single_p2(pic, comparisons)
ind = find(strcmp(pic.filename,{comparisons.pics.filename}));
if isempty(ind)
    text = 'Picture is either unusable or requires alignment and segmentation';
    return;
end
isdone = comparisons.lucas.done(ind,:);
text = sprintf('%d of %d comparisons precomputed (%.1f%%)\n',sum(isdone),length(comparisons.pics),sum(isdone)/length(comparisons.pics)*100);

%xx likely lucas matches

G = comparisons.hand.match&comparisons.hand.done;
G(boolean(eye(size(G)))) = true;
G = sparse(G);
[n,toads] = graphconncomp(G,'Weak',true);
toadcnt = arrayfun(@(x)sum(x==toads),1:n);
nmatches = toadcnt(toads(ind))-1;


mpics = comparisons.pics(toads==toads(ind));
years = zeros(size(mpics));
for i=1:length(mpics)
    years(i) = mpics(i).date(1);
end
nyears = range(years)+1;

ids = [mpics.ID];
ids = ids(ids>0&ids<3000);
nids = length(unique(ids));
if nmatches<1
    text = [text sprintf('No confirmed matches\n')];
else
    text = [text sprintf('%d confirmed match(es) spanning %d year(s)\n%d toe-clip ID(s) in matching pictures\n',nmatches,nyears,nids)];
end

function text = multi_p1(pics)
text = sprintf('%d pictures selected\n',length(pics));
%print number of years
years = zeros(size(pics));
for i=1:length(pics)
    years(i) = pics(i).date(1);
end
text = [text sprintf('captured from %d to %d\n',min(years),max(years))];

%print datasets
dsets = unique({pics.set});
text = [text sprintf('Datasets represented:\n')];
for i=1:length(dsets)
    text = [text sprintf('%s\n',dsets{i})];
end

%part 2 of multi description
function text = multi_p2(pics, comparisons)
%xx/xx comparisons precomputed
inds = zeros(size(pics));

for i=1:length(pics)
    ind = find(strcmp(pics(i).filename,{comparisons.pics.filename}));
    if isempty(ind)
        inds(i) = 0;
    else
        inds(i) = ind;
    end
end
inds = inds(inds>0);

isdone = comparisons.lucas.done(inds,:);
ndone = sum(isdone(:));
ntodo = length(comparisons.pics)*length(inds);

text = sprintf('%d/%d comparisons precomputed (%.1f%%)',ndone,ntodo,ndone/ntodo*100);
