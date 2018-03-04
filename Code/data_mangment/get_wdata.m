function data = get_wdata(pic)
load projectpath;
workingdir = 'Processing/';

[path,name,ext] = fileparts(pic.filename);
wfilepath = [projectpath workingdir path '/'];
wfilename = [name '_aligned.mat'];

if exist([wfilepath wfilename],'file')
    data = load([wfilepath wfilename]);
else
    data = [];
end