function mask = getMask(code)

record_path = getPath(code);
spotFin = load([record_path filesep 'spotFin.mat']);
mask = spotFin.fin;
