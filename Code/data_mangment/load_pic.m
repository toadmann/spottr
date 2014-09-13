function img = load_pic(pic)
load projectpath;

img = imread([projectpath 'Pictures/' pic.filename]);