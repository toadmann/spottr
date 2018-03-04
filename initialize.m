% Initialize Prints Charming
% You must always run this script before using the program
% Alan Schoen, 2014

% Set working directories
project_path = pwd;
data_path = [project_path filesep 'Data'];
if ~exist(data_path,'dir')
   mkdir(data_path);
end
setappdata(0,'project_path',project_path);
setappdata(0,'data_path',data_path);

% Add all code subdirectories to Matlab path
addpath(genpath([project_path filesep 'Code']));

%Get information about pictures in system
all_sets = getAllSets();
setappdata(0,'all_sets',all_sets);
all_codes = getAllCodes();
setappdata(0,'all_codes',all_codes);

