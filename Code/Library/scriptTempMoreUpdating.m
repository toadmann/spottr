
all_codes = getappdata(0,'all_codes');

for i=1:length(all_codes)
    prog = getDataProgress(all_codes{i});
    record_path = getPath(all_codes{i});
    photodata = load([record_path filesep 'photodata.mat']);
    photodata.toadidset = '';
    photodata.original_filename = '';
    if isempty(photodata.toadid)
        disp('MT');
        photodata.toadid = -1;
    end
    if prog.old_record
        old_record = load([record_path filesep 'old_record.mat']);
        photodata.original_filename = old_record.pic.filename;
        if photodata.toadid>0
            photodata.toadidset = old_record.pic.set;
        end
        
    end
        
    save([record_path filesep 'photodata.mat'],'-struct','photodata');
end
%% 

all_sets = getappdata(0,'all_sets');
setinfo.year = 2012;
setinfo.toeclip = 0;
setinfo.last_toad_no = 0; 

%%  add toe clip true/false
all_codes = getAllCodes;

for i=1:length(all_codes)
    record_path = getPath(all_codes{i});
    photodata = load([record_path filesep 'photodata.mat']);
    photodata.toeclip = false;
    save([record_path filesep 'photodata.mat'],'-struct','photodata');
end