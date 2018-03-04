% getMaskPar(code, data_path)
% variation on getPath for parallel computing
% getappdata was causing problems, so it gets the data path as a parameter
function mask = getMaskPar(code, data_path)
record_path = getPathPar(code, data_path);
spotFin = load([record_path filesep 'spotFin.mat']);
mask = spotFin.fin;
