% getPathPar(idcode, data_path)
% variation on getPath for parallel computing
% getappdata was causing problems, so it gets the data path as a parameter
function record_path = getPathPar(idcode, data_path)
record_path = [data_path filesep strrep(idcode,'#',filesep)];