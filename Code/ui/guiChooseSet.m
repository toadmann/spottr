function varargout = guiChooseSet(varargin)
% GUICHOOSESET MATLAB code for guiChooseSet.fig
%      UI for choosing the set to work with
%      Alan Schoen, 2014
%
%      GUICHOOSESET, by itself, creates a new GUICHOOSESET or raises the existing
%      singleton*.
%
%      H = GUICHOOSESET returns the handle to a new GUICHOOSESET or the handle to
%      the existing singleton*.
%
%      GUICHOOSESET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUICHOOSESET.M with the given input arguments.
%
%      GUICHOOSESET('Property','Value',...) creates a new GUICHOOSESET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiChooseSet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiChooseSet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiChooseSet

% Last Modified by GUIDE v2.5 13-May-2012 14:09:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiChooseSet_OpeningFcn, ...
                   'gui_OutputFcn',  @guiChooseSet_OutputFcn, ...
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


% --- Executes just before guiChooseSet is made visible.
function guiChooseSet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiChooseSet (see VARARGIN)

% Choose default command line output for guiChooseSet
handles.output = hObject;

all_sets = getAllSets();
setappdata(0,'all_sets',all_sets);

set(handles.list_sets,'String',all_sets);

setappdata(0,'current_set','');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiChooseSet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiChooseSet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_sets.
function list_sets_Callback(hObject, eventdata, handles)
% hObject    handle to list_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_sets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_sets


% --- Executes during object creation, after setting all properties.
function list_sets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_choose.
function button_choose_Callback(hObject, eventdata, handles)
% hObject    handle to button_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.list_sets,'String'));
chosen_set = contents{get(handles.list_sets,'Value')};

setappdata(0,'current_set',chosen_set);

guiExploreSet();

close(gcbf);


% --- Executes on button press in button_newset.
function button_newset_Callback(hObject, eventdata, handles)
% hObject    handle to button_newset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newname = inputdlg('Choose a name for the new set','Enter set name',1);
newname = newname{1};
setnames = cellstr(get(handles.list_sets,'String'));
if isempty(newname)||ismember(newname,setnames)
    disp('No set added');
    return;
end

data_path = getappdata(0,'data_path');
mkdir(data_path,newname);
setnames = getAllSets();
setappdata(0,'all_sets',setnames);
set(handles.list_sets,'String',setnames);
