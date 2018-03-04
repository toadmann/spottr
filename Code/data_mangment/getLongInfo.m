function string = getLongInfo(code)
record_path = getPath(code);
photodata = load([record_path,filesep,'photodata.mat']);

fdate = datestr(photodata.date, 'mmmm dd, yyyy');
dateline = sprintf('Taken on %s.', fdate);

idstr = 'No toad ID.';
if photodata.toadid>0
    idstr = sprintf('Toad id %s-%d.',photodata.toadidset,photodata.toadid);
end


encounternum = str2double(photodata.photoid);
if encounternum>0
    encstr = sprintf('Encounter number %d.',encounternum);
else
    encstr = photodata.photoid;
end

if photodata.toeclip
    tcstr = sprintf('Toe-clip ID: %d.',photodata.toeclipid);
else
    tcstr = 'Software does not have a toe-clip ID for this toad.';
end

string = sprintf('%s  %s\n%s\n%s',dateline,idstr,encstr,tcstr);