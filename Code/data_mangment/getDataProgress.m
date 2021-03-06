% getDataProgress(code)
% check which steps have been done for a toad
% Alan Schoen, 2014
function [prog] = getDataProgress(code)
names = {...
    'old_record',...
    'photodata',...
    'quality',...
    'marks',...
    'spotRect',...
    'spotParams',...
    'spotFin',...
    'compHand',...
    'compLucas'};
record_path = getPath(code);
for i=1:length(names)
    prog.(names{i}) = boolean(exist([record_path filesep names{i} '.mat'],'file'));
end