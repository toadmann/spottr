function varargout = guiEditPicture(varargin)
% GUIEDITPICTURE MATLAB code for guiEditPicture.fig
%      UI for editing the details of a picture
%      Alan Schoen, 2014
%
%      GUIEDITPICTURE, by itself, creates a new GUIEDITPICTURE or raises the existing
%      singleton*.
%
%      H = GUIEDITPICTURE returns the handle to a new GUIEDITPICTURE or the handle to
%      the existing singleton*.
%
%      GUIEDITPICTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIEDITPICTURE.M with the given input arguments.
%
%      GUIEDITPICTURE('Property','Value',...) creates a new GUIEDITPICTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiEditPicture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiEditPicture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiEditPicture

% Last Modified by GUIDE v2.5 14-May-2012 00:52:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiEditPicture_OpeningFcn, ...
                   'gui_OutputFcn',  @guiEditPicture_OutputFcn, ...
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


% --- Executes just before guiEditPicture is made visible.
function guiEditPicture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiEditPicture (see VARARGIN)

% Choose default command line output for guiEditPicture
handles.output = hObject;

%get code
handles.code = getappdata(0,'current_code');

record_path = getPath(handles.code);
photodata = load([record_path filesep 'photodata.mat']);
handles.base = loadBasePicture(handles.code);

all_sets = getappdata(0,'all_sets');
set(handles.dataset,'String',all_sets);
set(handles.timerid,'String',photodata.photoid);
set(handles.date,'String',datestr(photodata.date,'mm/dd/yyyy'));
if photodata.toeclip
    set(handles.toeclipid,'String',num2str(photodata.toeclipid));
else
    
end

if photodata.toadid>0
    set(handles.toadid,'String',num2str(photodata.toadid));
else
    set(handles.toadid,'String','');
end

%set box to set name
parts = regexp(handles.code,'#','split','once');
current_set = parts{1};
if (ismember(current_set, all_sets))
    setno = find(strcmp(current_set,all_sets));
    set(handles.dataset,'Value',setno);
else
    error('Problem with set');
end

%now set toad box
if photodata.toadid>0
    idset = photodata.toadidset;
    
    if (ismember(idset, all_sets))
        setno = find(strcmp(idset,all_sets));
        set(handles.dataset,'Value',setno);
    end
else
    set(handles.dataset,'Value',setno);
end


imshow(handles.base,'Parent',handles.axes1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiEditPicture wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiEditPicture_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function timerid_Callback(hObject, eventdata, handles)
% hObject    handle to timerid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timerid as text
%        str2double(get(hObject,'String')) returns contents of timerid as a double


% --- Executes during object creation, after setting all properties.
function timerid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timerid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double


% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function toadid_Callback(hObject, eventdata, handles)
% hObject    handle to toadid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toadid as text
%        str2double(get(hObject,'String')) returns contents of toadid as a double

% --- Executes during object creation, after setting all properties.
function toadid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toadid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dataset_Callback(hObject, eventdata, handles)
% hObject    handle to dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataset as text
%        str2double(get(hObject,'String')) returns contents of dataset as a double


% --- Executes during object creation, after setting all properties.
function dataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function id = convert_to_id(str)
id = str2double(str);
if id<0||isnan(id)
    id = -1;
end

function str = convert_to_cap_id(str)
id = str2double(str);
if id<0
    str = '';
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setnames = get(handles.dataset,'String');

record_path = getPath(handles.code);

photodata = load([record_path filesep 'photodata.mat']);
photodata.photoid = convert_to_cap_id(get(handles.timerid,'String'));
photodata.toadid = convert_to_id(get(handles.toadid,'String'));
photodata.date = datevec(get(handles.date,'String'));

toebox = get(handles.toeclipid,'String');
photodata.toeclip = ~isempty(toebox);
photodata.toeclipid = str2double(toebox);

save([record_path filesep 'photodata.mat'],'-struct','photodata');

%now move the file if necessary
setname = setnames{get(handles.dataset,'Value')};
parts = regexp(handles.code,'#','split','once');
if ~strcmp(setname,parts{1})
    movePicture(handles.code,setname);
end

%update all_codes
setappdata(0,'all_codes',getAllCodes());

closereq;


% --- Executes on button press in rotate.
function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.base = imrotate(handles.base,90);
guidata(hObject,handles);
imshow(handles.base,'Parent',handles.axes1);

function toeclipid_Callback(hObject, eventdata, handles)
% hObject    handle to toeclipid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toeclipid as text
%        str2double(get(hObject,'String')) returns contents of toeclipid as a double


% --- Executes during object creation, after setting all properties.
function toeclipid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toeclipid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
