function year = getSetYear(setname)

year = regexp(setname, '20[0123]\d', 'match');

if ~isempty(year)
    year = str2num(year{1});
else
    year = 0;
end