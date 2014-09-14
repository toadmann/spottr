function varargout = newPicture(varargin)
% NEWPICTURE MATLAB code for newPicture.fig
%      UI for adding a new picture
%      Alan Schoen, 2014
%
%      NEWPICTURE, by itself, creates a new NEWPICTURE or raises the existing
%      singleton*.
%
%      H = NEWPICTURE returns the handle to a new NEWPICTURE or the handle to
%      the existing singleton*.
%
%      NEWPICTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWPICTURE.M with the given input arguments.
%
%      NEWPICTURE('Property','Value',...) creates a new NEWPICTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before newPicture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to newPicture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help newPicture

% Last Modified by GUIDE v2.5 14-May-2012 00:42:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @newPicture_OpeningFcn, ...
                   'gui_OutputFcn',  @newPicture_OutputFcn, ...
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


% --- Executes just before newPicture is made visible.
function newPicture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to newPicture (see VARARGIN)

% Choose default command line output for newPicture
handles.output = hObject;

current_set = getappdata(0,'current_set');
setnames = getAllSets();
set(handles.dataset,'String', setnames);

if (ismember(current_set, setnames))
    setno = find(strcmp(current_set,setnames));
    set(handles.dataset,'Value',setno);
end


%get filename
handles.filename = getappdata(0,'current_filename');
if isempty(handles.filename)
    %error('Please provde a filename,"setappdata(0,''current_filename'',__FILENAME__)"');
    [name,path] = uigetfile({'*.jpg;*.JPG;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'},...
        'Choose a picture',...
        '~/Pictures/');
        %'MultiSelect', 'on'...
    handles.filename = [path,name];
end

iminf = imfinfo(handles.filename);
if isfield(iminf,'DigitalCamera')
    picturedate = iminf.DigitalCamera.DateTimeOriginal;
    tstamp = regexp(picturedate,'^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})', 'tokens','once');
    tstamp = str2double(tstamp);
else
    tstamp = datevec(now);
end

set(handles.date,'String',datestr(tstamp,'mm/dd/yyyy'));

handles.orig.tstamp = tstamp;
handles.orig.filename = handles.filename;
handles.orig.img = imread(handles.filename);

imshow(handles.orig.img,'Parent',handles.axes1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes newPicture wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = newPicture_OutputFcn(hObject, eventdata, handles) 
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

function num = next_id(dname)
contents = dir(dname);
maxpic = 0;
for i=1:length(contents)
    num = str2double(contents(i).name);
    if contents(i).isdir&&~isempty(num)
        maxpic = max(maxpic, num);
    end
end
num = maxpic+1;


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
setname = setnames{get(handles.dataset,'Value')};

photodata = [];
photodata.photoid = convert_to_cap_id(get(handles.timerid,'String'));
photodata.toadid = -1;
photodata.date = datevec(get(handles.date,'String'));
photodata.use = true;
photodata.toadidset = setname;
photodata.original_filename = handles.orig.filename;

toebox = get(handles.toadid,'String');
photodata.toeclip = ~isempty(toebox);
photodata.toeclipid = str2double(toebox);

data_path = getappdata(0,'data_path');
if ~exist([data_path filesep setname],'dir')
    mkdir(data_path,setname);
end
set_path = [data_path filesep setname];

idnum = next_id(set_path);
idcode = [setname '#' num2str(idnum)];
record_path = getPath(idcode);
mkdir(set_path,num2str(idnum));

orig = handles.orig;
%save image as jpeg
saveBasePicture(idcode, orig)
%save([record_path filesep 'original.mat'], '-struct','orig');
save([record_path filesep 'photodata.mat'],'-struct','photodata');

setappdata(0,'current_code',idcode);

%update all_codes
all_codes = getappdata(0,'all_codes');
all_codes = cat(2,all_codes,idcode);
setappdata(0,'all_codes',all_codes);

closereq;


% --- Executes on button press in rotate.
function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.orig.img = imrotate(handles.orig.img,90);
guidata(hObject,handles);
imshow(handles.orig.img,'Parent',handles.axes1);
