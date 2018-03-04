function record_path = getPath(idcode)
data_path = getappdata(0,'data_path');
record_path = [data_path filesep strrep(idcode,'#',filesep)];