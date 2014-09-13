function [set, num] = getSet(code)

parts = regexp(code,'#','split','once');

set = parts{1};
num = str2double(parts{2});