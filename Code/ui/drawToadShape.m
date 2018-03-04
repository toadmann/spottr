% drawToadShape(code, ah)
% draws the shape of a toad on specified axis
% Alan Schoen, 2014
function h = drawToadShape(code, ah)
if nargin<2
      ah = gca;
end
h = [];

% check that marks are done
prog = getDataProgress(code);
if(prog.marks)
   % load marks
   record_path = getPath(code);
   marks = load([record_path filesep 'marks.mat']);
   % draw toad
   h = zeros(1,2);
   head = createhead(marks.left, marks.right);
   h(1) = line(head(:,1),head(:,2),'Parent',ah);
   body = createbody(marks.left,marks.right, marks.tail);
   h(2) = line(body(:,1),body(:,2),'Parent',ah);
end