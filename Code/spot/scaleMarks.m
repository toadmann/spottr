% scaleMarks(code, scale)
% scales the marks on an image to adjust for resolution changes
% Alan Schoen, 2014
function scaleMarks(code, scale)
prog = getDataProgress(code);
if(prog.marks)
   record_path = getPath(code);
   marks = load([record_path filesep 'marks.mat']);
   marks.left = scale*marks.left;
   marks.right = scale*marks.right;
   marks.tail = scale*marks.tail;
   save([record_path filesep 'marks.mat'],'-struct','marks');
end