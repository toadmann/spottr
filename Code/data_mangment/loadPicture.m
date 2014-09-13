function orig = loadPicture(code)
record_path = getPath(code);
orig = load([record_path filesep 'original.mat']);
