
projectpath = pwd;
setappdata(0,'project_path',projectpath);
setappdata(0,'data_path',[projectpath filesep 'Data']);

addpath(genpath([projectpath filesep 'Code']));

all_sets = getAllSets();
setappdata(0,'all_sets',all_sets);

all_codes = getAllCodes();
setappdata(0,'all_codes',all_codes);

