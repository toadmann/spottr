function string = getShortInfo(code)
record_path = getPath(code);
photodata = load(fullfile(record_path,'photodata.mat'));

idstr = 'No toad ID';
if photodata.toadid>0
    idstr = sprintf('%s-%d',photodata.toadidset,photodata.toadid);
end

string = sprintf('%s, cap %s (%s)',idstr,photodata.photoid,datestr(photodata.date,'mm/dd/yyyy'));
