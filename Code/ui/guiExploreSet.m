function varargout = guiExploreSet(varargin)
% GUIEXPLORESET MATLAB code for guiExploreSet.fig
%      UI to view pictures in a data set
%      Alan Schoen, 2014
%
%      GUIEXPLORESET, by itself, creates a new GUIEXPLORESET or raises the existing
%      singleton*.
%
%      H = GUIEXPLORESET returns the handle to a new GUIEXPLORESET or the handle to
%      the existing singleton*.
%
%      GUIEXPLORESET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIEXPLORESET.M with the given input arguments.
%
%      GUIEXPLORESET('Property','Value',...) creates a new GUIEXPLORESET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiExploreSet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiExploreSet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiExploreSet

% Last Modified by GUIDE v2.5 14-May-2012 11:05:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiExploreSet_OpeningFcn, ...
                   'gui_OutputFcn',  @guiExploreSet_OutputFcn, ...
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


% --- Executes just before guiExploreSet is made visible.
function guiExploreSet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiExploreSet (see VARARGIN)

% Choose default command line output for guiExploreSet
handles.output = hObject;

set_name = getappdata(0,'current_set');
set(hObject,'Name',set_name);

if isempty(set_name)
    error('Please specify a data set "setappdata(0,''current_set'',__SET_NAME__)"');
end
handles.set_name = set_name;

handles = update_box(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiExploreSet wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%update the box
function handles = update_box(handles)
codes = getCodes(handles.set_name);
handles.codes = codes;

%order pictures
picnums = zeros(size(codes));
for i=1:length(codes)
    parts = regexp(codes{i},'#','split','once');
    picnums(i) = str2double(parts{2});
end

[~,ord] = sort(picnums);
codes = codes(ord);
picnums = picnums(ord);

%assemble strings to display
box_contents = cell(size(codes));
for i=1:length(codes)
    box_contents{i} = getShortInfo(codes{i});
end

ind = get(handles.list_pictures, 'Value');
ind = min(ind, length(box_contents));
ind = max(ind, 1);
set(handles.list_pictures,'Value', ind);
set(handles.list_pictures,'UserData',codes);
set(handles.list_pictures,'String',box_contents);
set(handles.list_pictures,'Max',length(box_contents));


% --- Outputs from this function are returned to the command line.
function varargout = guiExploreSet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_pictures.
function list_pictures_Callback(hObject, eventdata, handles)
% hObject    handle to list_pictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_pictures contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_pictures

group1 = [handles.button_add,handles.button_mark,handles.button_matches];
group2 = [handles.button_info,handles.button_delete];

boxcodes = get(hObject,'UserData');
codes = boxcodes(get(hObject,'Value'));



if length(codes)==1
    code = codes{1};
    set([group1,group2],'Enable','on');
    
    pic = loadBasePicture(code);

    imshow(pic,'Parent',handles.axes1);

    handles.code = code;
    guidata(hObject,handles);
    
elseif length(codes)>1
    set([group1,group2],'Enable','off');
else
    set([group1,group2],'Enable','off');
end


% --- Executes during object creation, after setting all properties.
function list_pictures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_pictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_delete.
function button_delete_Callback(hObject, eventdata, handles)
% hObject    handle to button_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Are you sure you want to delete this picture','Confirm delete','Yes','No','No');

if strcmp(choice,'Yes')
    deletePicture(handles.code);
    handles = update_box(handles);
    guidata(hObject, handles);
end

% --- Executes on button press in button_add.
function button_add_Callback(hObject, eventdata, handles)
% hObject    handle to button_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'current_filename','');

nph = newPicture();
%set(gcbf,'Visible','off');
set(nph,'WindowStyle','modal');
uiwait(nph);
%set(gcbf,'Visible','on');

handles = update_box(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in button_mark.
function button_mark_Callback(hObject, eventdata, handles)
% hObject    handle to button_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'current_code',handles.code);
pth = placeToad;
set(pth,'WindowStyle','modal');
uiwait(pth);

% --- Executes on button press in button_matches.
function button_matches_Callback(hObject, eventdata, handles)
% hObject    handle to button_matches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'current_code',handles.code);
sh = guiSearch;
%set(gcbf,'Visible','off');
set(sh,'WindowStyle','modal');
uiwait(sh);
%set(gcbf,'Visible','on');

handles = update_box(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in button_info.
function button_info_Callback(hObject, eventdata, handles)
% hObject    handle to button_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'current_code',handles.code);
eph = guiEditPicture();
%set(gcbf,'Visible','off');
set(eph,'WindowStyle','modal');
uiwait(eph);
%set(gcbf,'Visible','on');

handles = update_box(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in button_batch.
function button_batch_Callback(hObject, eventdata, handles)
% hObject    handle to button_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boxcodes = get(handles.list_pictures,'UserData');
codes = boxcodes(get(handles.list_pictures,'Value'));
searchBatch(codes);

handles = update_box(handles);

% Update handles structure
guidata(hObject, handles);
