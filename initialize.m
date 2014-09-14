
project_path = pwd;
data_path = [project_path filesep 'Data'];

if ~exist(data_path,'dir')
   mkdir(data_path);
end

setappdata(0,'project_path',project_path);
setappdata(0,'data_path',data_path);

addpath(genpath([project_path filesep 'Code']));

all_sets = getAllSets();
setappdata(0,'all_sets',all_sets);

all_codes = getAllCodes();
setappdata(0,'all_codes',all_codes);

