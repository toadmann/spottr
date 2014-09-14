function varargout = placeToad(varargin)
% PLACETOAD MATLAB code for placeToad.fig
%      UI for placing the toad shape on a picture
%      Alan Schoen, 2014
%
%      PLACETOAD, by itself, creates a new PLACETOAD or raises the existing
%      singleton*.
%
%      H = PLACETOAD returns the handle to a new PLACETOAD or the handle to
%      the existing singleton*.
%
%      PLACETOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLACETOAD.M with the given input arguments.
%
%      PLACETOAD('Property','Value',...) creates a new PLACETOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before placeToad_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to placeToad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help placeToad

% Last Modified by GUIDE v2.5 12-May-2012 21:24:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @placeToad_OpeningFcn, ...
                   'gui_OutputFcn',  @placeToad_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%marking functions
function markseq(hObject, eventdata,redo)
handles = guidata(hObject);


point = get(gca,'CurrentPoint');
point = round(point(1,1:2));
if (~strcmp(eventdata,'init'))&&inrect(point,get(gca,'XLim'),get(gca,'YLim'))
    if isempty(handles.data.mark.left)
        handles.data.mark.left = point;
    elseif isempty(handles.data.mark.right)
        handles.data.mark.right = point;
    elseif isempty(handles.data.mark.tail)
        handles.data.mark.tail = point;
    end
end

handles = drawmarks(handles);
if nargin>2
    delete(handles.drawn.points)
    handles.drawn.points = [];
    handles.data.mark.(redo) = [];
end
if isempty(handles.data.mark.left)
    set(gcf,'WindowButtonMotionFcn',@markleft);
    set(gcf,'WindowButtonDownFcn',@markseq);
elseif isempty(handles.data.mark.right)
    set(gcf,'WindowButtonMotionFcn',@markright);
    set(gcf,'WindowButtonDownFcn',@markseq);
elseif isempty(handles.data.mark.tail)
    set(gcf,'WindowButtonMotionFcn',@marktail);
    set(gcf,'WindowButtonDownFcn',@markseq);
else
    clearfcns;
    handles = placepoints(handles);
end

if mark_done(handles)
    set(handles.radiobutton_task_seg,'Enable','on');
else
    set(handles.radiobutton_task_seg,'Enable','off');
end

% Update handles structure
guidata(gcf, handles);

function clearfcns(hObject,wawa)
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonUpFcn',[]);
set(gcf,'WindowButtonDownFcn',[])


function handles = placepoints(handles)
if ~isempty(handles.data.mark.left)&&~isempty(handles.data.mark.right)&&~isempty(handles.data.mark.tail)
    ph1 = line(handles.data.mark.left(1),handles.data.mark.left(2),'Color','r','Marker','+');
    set(ph1,'ButtonDownFcn',@(x,y)markseq(x,y,'left'))
    ph2 = line(handles.data.mark.right(1),handles.data.mark.right(2),'Color','r','Marker','+');
    set(ph2,'ButtonDownFcn',@(x,y)markseq(x,y,'right'))
    ph3 = line(handles.data.mark.tail(1),handles.data.mark.tail(2),'Color','r','Marker','+');
    set(ph3,'ButtonDownFcn',@(x,y)markseq(x,y,'tail'))
    handles.drawn.points = [ph1,ph2,ph3];
end

function inside = inrect(point,rectx,recty)
inside = (point(:,1)>rectx(1))&(point(:,2)>recty(1))&(point(:,1)<=rectx(2))&(point(:,2)<=recty(2));

function inside = insize(point,size)
inside = all(point>0)&&all(point<=size);

function markleft(hObject,wawa)
handles = guidata(hObject);
point = get(gca,'CurrentPoint');
point = round(point(1,1:2));
if inrect(point,get(gca,'XLim'),get(gca,'YLim'))
    handles.data.mark.left = point;
    handles = drawmarks(handles);
    handles.data.mark.left = [];
    % Update handles structure
    guidata(hObject, handles);
end

function markright(hObject,wawa)
handles = guidata(hObject);
point = get(gca,'CurrentPoint');
point = point(1,1:2);
if inrect(point,get(gca,'XLim'),get(gca,'YLim'))
    handles.data.mark.right = point;
    handles = drawmarks(handles);
    handles.data.mark.right = [];
    % Update handles structure
    guidata(hObject, handles);
end

function marktail(hObject,wawa)
handles = guidata(hObject);
point = get(gca,'CurrentPoint');
point = point(1,1:2);
if inrect(point,get(gca,'XLim'),get(gca,'YLim'))
    handles.data.mark.tail = point;
    handles = drawmarks(handles);
    handles.data.mark.tail = [];
    % Update handles structure
    guidata(hObject, handles);
end

function handles = drawmarks(handles)
if ~isempty(handles.data.mark.left)
    if ~isempty(handles.data.mark.right)
        head = createhead(handles.data.mark.left, handles.data.mark.right);
        delete(handles.drawn.head);
        handles.drawn.head = line(head(:,1),head(:,2));
    
        if ~isempty(handles.data.mark.tail)
            body = createbody(handles.data.mark.left,handles.data.mark.right, handles.data.mark.tail);
            delete(handles.drawn.body);
            handles.drawn.body = line(body(:,1),body(:,2));
        end
    end
end



% --- Executes just before placeToad is made visible.
function placeToad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to placeToad (see VARARGIN)

% Choose default command line output for placeToad


%set(hObject,'CloseRequestFcn',close_request);
warning off MATLAB:inpolygon:ModelingWorld;
set(gcf,'DefaultLineLineWidth',3);

handles.output = hObject;

projectpath = getappdata(0,'project_path');
handles.workingdir = 'Processing/';

%get pictures
handles.piccode = getappdata(0,'current_code');
if isempty(handles.piccode);
    error('Please set a picture code, "setappdata(0,''current_code'',__CODE__)"');
end

handles.user = '';
handles = load_picture(hObject, handles);

% Update handles structure
guidata(hObject, handles);

set_task(hObject,[],handles);


% UIWAIT makes placeToad wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = placeToad_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

record_path = getPath(handles.piccode);

marks = [];
marks.left = handles.data.mark.left;
marks.right = handles.data.mark.right;
marks.tail = handles.data.mark.tail;
save([record_path filesep 'marks.mat'],'-struct','marks');

spotParams = [];
spotParams.pos = handles.data.wshed.posregion;
spotParams.neg = handles.data.wshed.negregion;
spotParams.fgthresh = handles.data.wshed.fgthresh;
spotParams.edge_sigma = handles.data.wshed.edge_sigma;
save([record_path filesep 'spotParams.mat'],'-struct','spotParams');

spotFin = [];
spotFin.fin = handles.data.wshed.spots.fin;
save([record_path filesep 'spotFin.mat'],'-struct','spotFin');

%save quality data
quality = handles.quality;
save([record_path filesep 'quality.mat'],'-struct','quality');

close;

function reset_problem(handles)
set(handles.usable, 'Value',handles.quality.usability);


%Load a new picture
function handles = load_picture(hObject, handles)
record_path = getPath(handles.piccode);
photodata = loadPhotodata(handles.piccode);
base = loadBasePicture(handles.piccode);

set(handles.text2, 'String', photodata.photoid);
handles.data = init_data();

if exist([record_path filesep 'marks.mat'],'file')
    marks = load([record_path filesep 'marks.mat']);
    handles.data.mark.left = marks.left;
    handles.data.mark.right = marks.right;
    handles.data.mark.tail = marks.tail;
end

if exist([record_path filesep 'spotParams.mat'],'file')
    spotParams = load([record_path filesep 'spotParams.mat']);
    handles.data.wshed.posregion = spotParams.pos;
    handles.data.wshed.negregion = spotParams.neg;
    handles.data.wshed.fgthresh = spotParams.fgthresh;
    handles.data.wshed.edge_sigma = spotParams.edge_sigma;
end

if exist([record_path filesep 'quality.mat'],'file')
    quality = load([record_path filesep 'quality.mat']);
else
    quality = [];
    quality.usability = 1;
    quality.problems.cutoff = false;
    quality.problems.nospots = false;
    quality.problems.toadcondition = false;
    quality.problems.optics = false;
    quality.problems.other = false;
end

handles.quality = quality;
reset_problem(handles);
set(handles.radiobutton_seg_spots,'Value',true);

if ~mark_done(handles)
    set(handles.radiobutton_task_seg,'Enable','off');
    set(handles.radiobutton_task_agn,'Value',true);
end


handles.img = base;
handles.cutoff_enabled = false;
if(handles.quality.problems.cutoff)
    handles = pad(handles);
    set_task(hObject,[],handles);
end





%set current task
function set_task(hObject,eventdata,handles)
cla;
clearfcns;
%do alignment
if (get(handles.radiobutton_task_agn,'Value'))
    set(allchild(handles.uipanel_seg),'Enable','off');
    %axes(handles.axes1);
    handles.im_handle = imshow(handles.img);
    
    %set(hObject, 'Pointer', 'crosshair');
    handles.drawn.head = [];
    handles.drawn.body = [];
    handles.drawn.points = [];
    % Update handles structure
    guidata(hObject, handles);
    
    markseq(hObject,'init');
    
else
    set(allchild(handles.uipanel_seg),'Enable','on');
    tform = align_tform(handles.data.mark.left,handles.data.mark.right,handles.data.mark.tail);
    
    temp = imtransform(handles.img,tform,'XData',[1 128],'YData',[1 256],'Size',[256,128]);
    handles.data.aligned = double(temp)/255;
    handles.data.alignedgray = spot_I(handles.data.aligned, handles.data.wshed);
    handles.im_handle = imshow(handles.data.aligned);
    handles.drawn.other = [];
    
    %initialize data
    [handles.data.wshed.fg.fin,handles.data.wshed.fg.raw] = spot_fg(handles.data.alignedgray,handles.data.wshed);
    [handles.data.wshed.edges.fin,handles.data.wshed.edges.raw] = spot_edges(handles.data.alignedgray,handles.data.wshed);
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
    
    handles = switch_seg_task(handles);
    
    % Update handles structure
    guidata(hObject, handles);
end

function isdone = mark_done(handles)
isdone = ~isempty(handles.data.mark.left)&~isempty(handles.data.mark.right)&~isempty(handles.data.mark.tail);

% --- Executes when selected object is changed in uipanel_task.
function uipanel_task_SelectionChangeFcn(hObject, eventdata, handles)
set_task(hObject,eventdata,handles);


function startdrawing(hObject,event)
handles = guidata(hObject);
set(handles.im_handle,'ButtonDownFcn',[]);
set(gcf,'WindowButtonUpFcn',@stopdrawing);
set(gcf,'WindowButtonMotionFcn',@dodrawing);

neg = false;
if strcmp(get(gcf,'SelectionType'),'alt');
    neg = true;
end

if get(handles.radiobutton_seg_spots, 'Value');
    if neg
        handles.data.wshed.negregion(cellfun(@(x)isempty(x),handles.data.wshed.negregion)) = [];
        handles.data.wshed.negregion = cat(2,handles.data.wshed.negregion,{zeros(0,2)});
    else
        handles.data.wshed.posregion(cellfun(@(x)isempty(x),handles.data.wshed.posregion)) = [];
        handles.data.wshed.posregion = cat(2,handles.data.wshed.posregion,{zeros(0,2)});
    end
    % Update handles structure
    guidata(hObject, handles);
end
dodrawing(hObject,event);

function dodrawing(hObject,event)
point = get(gca,'CurrentPoint');
point = round(point(1,1:2));
if ~inrect(point,get(gca,'XLim'),get(gca,'YLim'))
    return;
end
neg = false;
if strcmp(get(gcf,'SelectionType'),'alt');
    neg = true;
end
handles = guidata(hObject);

if get(handles.radiobutton_seg_plain, 'Value');
    handles.data.wshed.fg.pos(point(2),point(1)) = ~neg;
    handles.data.wshed.fg.neg(point(2),point(1)) = neg;
    handles.data.wshed.fg.fin(point(2),point(1)) = ~neg;
elseif get(handles.radiobutton_seg_edges, 'Value');
    handles.data.wshed.edges.pos(point(2),point(1)) = ~neg;
    handles.data.wshed.edges.neg(point(2),point(1)) = neg;
    handles.data.wshed.edges.fin(point(2),point(1)) = double(~neg)*max(handles.data.wshed.edges.fin(:));
elseif get(handles.radiobutton_seg_spots, 'Value');
    if neg
        handles.data.wshed.negregion{end} = cat(1,handles.data.wshed.negregion{end},point);
    else
        handles.data.wshed.posregion{end} = cat(1,handles.data.wshed.posregion{end},point);
    end
end
handles = dispseg(handles);
% Update handles structure
guidata(hObject, handles);


function handles = dispseg(handles)
delete(handles.drawn.other);
handles.drawn.other = [];
if get(handles.radiobutton_seg_plain, 'Value');
    fg = handles.data.wshed.fg.pos;
    fg = cat(3,zeros(size(fg)),0.3*fg,zeros(size(fg)));
    set(handles.im_handle,'CData',min(1.0,handles.data.aligned+fg));
elseif get(handles.radiobutton_seg_edges, 'Value');
    ed = handles.data.wshed.edges.fin;
    ed = ed/max(ed(:));
    ed = cat(3,zeros(size(ed)),ed,zeros(size(ed)));
    set(handles.im_handle,'CData',min(1.0,0.5*handles.data.aligned+0.7*ed));
elseif get(handles.radiobutton_seg_spots, 'Value');
    %draw positive regions
    for i=1:length(handles.data.wshed.posregion)
        region = handles.data.wshed.posregion{i};
        if size(region,1)>2
            todraw = cat(1,region,region(1,:));
            lh = line(todraw(:,1),todraw(:,2),'Color','b');
            handles.drawn.other = cat(1,handles.drawn.other,lh);
            set(lh,'ButtonDownFcn',@(x,y)delete_posregion(x,y,i,length(handles.drawn.other)));
        end
    end
    %draw negative regions
    for i=1:length(handles.data.wshed.negregion)
        region = handles.data.wshed.negregion{i};
        if size(region,1)>2
            todraw = cat(1,region,region(1,:));
            lh = line(todraw(:,1),todraw(:,2),'Color','r');
            handles.drawn.other = cat(1,handles.drawn.other,lh);
            set(lh,'ButtonDownFcn',@(x,y)delete_negregion(x,y,i,length(handles.drawn.other)));
        end
    end
    todraw = handles.data.wshed.spots.fin;
    todraw = cat(3,zeros(size(todraw)),0.3*todraw,zeros(size(todraw)));
    set(handles.im_handle,'CData',min(1.0,handles.data.aligned+todraw));
    
    
end

function h = drawconncomp(bw)
B = bwboundaries(bw, 'noholes');
h = [];
%props = regionprops(cc,'PixelList');
for i=1:length(B)
    todraw = B{i};
    h = cat(1,h,line(todraw(:,1),todraw(:,2)));
end

function stopdrawing(hObject,event)
handles = guidata(hObject);
set(handles.im_handle,'ButtonDownFcn',@startdrawing);
set(gcf,'WindowButtonUpFcn',[]);
set(gcf,'WindowButtonMotionFcn',[]);
if get(handles.radiobutton_seg_spots, 'Value')
    handles = update_handmasks(handles);
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
    handles = dispseg(handles);
    % Update handles structure
    guidata(hObject, handles);
end

function delete_posregion(hObject,event,regno,lineno)
if strcmp(get(gcf,'SelectionType'),'alt')
    handles = guidata(gcf);
    delete(hObject);
    handles.drawn.other(lineno) = [];
    handles.data.wshed.posregion{regno} = [];
    handles = update_handmasks(handles);
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
    handles = dispseg(handles);
    guidata(gcf,handles);
end

function delete_negregion(hObject,event,regno,lineno)
if strcmp(get(gcf,'SelectionType'),'alt')
    handles = guidata(gcf);
    delete(hObject);
    handles.drawn.other(lineno) = [];
    handles.data.wshed.negregion{regno} = [];
    handles = update_handmasks(handles);
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
    handles = dispseg(handles);
    guidata(gcf,handles);
end

function handles = update_handmasks(handles)
sz = size(handles.data.wshed.spots.pos);
handles.data.wshed.spots.pos = region2mask(handles.data.wshed.posregion,sz);
handles.data.wshed.spots.neg = region2mask(handles.data.wshed.negregion,sz);

function mask = region2mask(region, sz)
mask = false(sz);
[X,Y] = meshgrid(1:sz(2),1:sz(1));
for i=1:length(region)
    r = region{i};
    if size(r,1)>2
        [in,on] = inpolygon(X,Y,r(:,1),r(:,2));
        inds = sub2ind(sz,Y(in|on),X(in|on));
        mask(inds) = true;
    end
end

%limit true valies to a specific region
function mask = restrict_mask(mask,region)
[Y,X] = find(mask);
[valid] = inpolygon(X,Y,region(:,1),region(:,2));
X = X(~valid);
Y = Y(~valid);
inds = sub2ind(size(mask),Y,X);
mask(inds) = false;

%remove false valies from a specific region
function mask = region_mask(mask,region)
[Y,X] = find(~mask);
[valid] = inpolygon(X,Y,region(:,1),region(:,2));
X = X(valid);
Y = Y(valid);
inds = sub2ind(size(mask),Y,X);
mask(inds) = true;

%remove true valies from a specific region
function mask = limit_mask(mask,region)
[Y,X] = find(mask);
[valid] = inpolygon(X,Y,region(:,1),region(:,2));
X = X(valid);
Y = Y(valid);
inds = sub2ind(size(mask),Y,X);
mask(inds) = false;


% --- Executes when selected object is changed in uipanel_seg.
function uipanel_seg_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_seg 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = switch_seg_task(handles);
% Update handles structure
guidata(hObject, handles);

function handles = switch_seg_task(handles)
set(handles.im_handle,'ButtonDownFcn',@startdrawing);
if get(handles.radiobutton_seg_plain, 'Value');
elseif get(handles.radiobutton_seg_edges, 'Value');
    [handles.data.wshed.edges.fin,handles.data.wshed.edges.raw] = spot_edges(handles.data.alignedgray,handles.data.wshed);
elseif get(handles.radiobutton_seg_spots, 'Value');
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
end
update_slider_seg(handles);
handles = dispseg(handles);


function update_slider_seg(handles)
if get(handles.radiobutton_seg_plain, 'Value')
    set(handles.slider_seg,'Enable','off');
elseif get(handles.radiobutton_seg_spots, 'Value')
    set(handles.slider_seg,'Enable','on');
    val = handles.data.wshed.fgthresh;
    val = (val-80)/(99-80);
    set(handles.slider_seg, 'Value',val);
elseif get(handles.radiobutton_seg_edges, 'Value');
    set(handles.slider_seg,'Enable','on');
    val = handles.data.wshed.edge_sigma;
    val = (val-1)/(4-1);
    set(handles.slider_seg, 'Value',val);
end

% --- Executes on slider movement.
function slider_seg_Callback(hObject, eventdata, handles)
% hObject    handle to slider_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject,'Value');
if get(handles.radiobutton_seg_plain, 'Value')
elseif get(handles.radiobutton_seg_edges, 'Value');
    handles.data.wshed.edge_sigma = 1+val*(4-1);
    [handles.data.wshed.edges.fin,handles.data.wshed.edges.raw] = spot_edges(handles.data.alignedgray,handles.data.wshed);
elseif get(handles.radiobutton_seg_spots, 'Value');
    handles.data.wshed.fgthresh = 80+val*(99-80);
    [handles.data.wshed.fg.fin,handles.data.wshed.fg.raw] = spot_fg(handles.data.alignedgray,handles.data.wshed);
    [handles.data.wshed.spots.fin,handles.data.wshed.spots.raw] = wshed_4gui(handles.data.alignedgray,handles.data.wshed);
end
handles = dispseg(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_seg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes during object creation, after setting all properties.
function usable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to usable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%pad a cutoff image
function handles = pad(handles)
if ~handles.cutoff_enabled
    img = handles.img;
    bgcol = mean(mean(img,1),2);
    npadrows = round(0.2*size(img,1));
    img = cat(1,img,repmat(bgcol,[npadrows size(img,2) 1]));
    handles.img = img;
    %set(handles.im_handle,'CData',img);
    handles.cutoff_enabled = true;
end

% --- Executes on button press in button_cutoff.
function button_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to button_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.quality.problems.cutoff = true;
handles = pad(handles);
guidata(hObject,handles);

set_task(hObject,[],handles);
