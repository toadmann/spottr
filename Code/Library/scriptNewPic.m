%setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/120504R/IMGP0024.JPG');
setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/120503R/IMGP0016.JPG');
setappdata(0,'current_code',[]);
nph = newPicture;
uiwait(nph);
piccode = getappdata(0,'current_code');
pth = placeToad();
uiwait(pth);
sh = guiSearch();


%%

setappdata(0,'current_code','2012#5');
sh = guiSearch();


%%

%setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/Road/IMGP0016.JPG');
%setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/Road/IMGP0019.JPG');
%setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/Road/IMGP0022.JPG');
%setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/Road/IMGP0024.JPG');
setappdata(0,'current_filename','/Users/alanschoen/Desktop/2012 Pics/Road/IMGP0025.JPG');

setappdata(0,'current_code',[]);
nph = newPicture;
uiwait(nph);
piccode = getappdata(0,'current_code');
pth = placeToad();
uiwait(pth);

%%
record_path = getPath('2012#5');
pd = load([record_path filesep 'photodata.mat'])


%%

record_path = getPath(piccode);
pic1 = load([getPath(piccode) filesep 'spotFin.mat']);
allcodes = getAllCodes();


touse = false(size(allmasks));
for i=1:length(allcodes)
    record_path = getPath(allcodes{i});
    pd = load([record_path filesep 'photodata.mat']);
    
    finexists = exist([record_path filesep 'spotFin.mat'],'file');
    
    touse(i) = pd.use&&finexists;
end

allcodes = allcodes(touse);
allmasks = cell(size(allcodes));

for i=1:length(allcodes)
    record_path = getPath(allcodes{i});
    tp = load([record_path filesep 'spotFin.mat']);
    allmasks{i} = tp.fin;
end

%%

luccors = zeros(size(allmasks));
pic1 = pic1.fin;
for i=1:length(allmasks)
    [~, ~, luc,~] = jiggle_mask(pic1,allmasks{i});
    luccors(i) = luc;
end

%%

figure(2)
record_path = getPath('2012#1');
orig = load([record_path filesep 'original.mat']);
imshow(orig.img)
