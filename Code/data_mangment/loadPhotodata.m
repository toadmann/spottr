function photodata = loadPhotodata(code)
record_path = getPath(code);
photodata = load([record_path filesep 'photodata.mat']);
