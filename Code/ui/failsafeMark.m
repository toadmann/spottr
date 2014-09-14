% Ensure that a picture has been maked
% Alan Schoen, 2014
function failsafeMark(code)
prog = getDataProgress(code);
if ~prog.spotFin
    disp('You need to mark this picture');
    setappdata(0,'current_code',code);
    pth = placeToad;
    set(pth,'WindowStyle','modal');
    uiwait(pth);
end