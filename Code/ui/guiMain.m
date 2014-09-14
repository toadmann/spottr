function varargout = guiMain(varargin)
% GUIMAIN MATLAB code for guiMain.fig
%      UI for main screen
%      Alan Schoen, 2014
%
%      GUIMAIN, by itself, creates a new GUIMAIN or raises the existing
%      singleton*.
%
%      H = GUIMAIN returns the handle to a new GUIMAIN or the handle to
%      the existing singleton*.
%
%      GUIMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMAIN.M with the given input arguments.
%
%      GUIMAIN('Property','Value',...) creates a new GUIMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiMain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiMain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiMain

% Last Modified by GUIDE v2.5 12-May-2012 21:27:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiMain_OpeningFcn, ...
                   'gui_OutputFcn',  @guiMain_OutputFcn, ...
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


% --- Executes just before guiMain is made visible.
function guiMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiMain (see VARARGIN)

% Choose default command line output for guiMain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiMain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiMain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_add.
function button_add_Callback(hObject, eventdata, handles)
% hObject    handle to button_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'current_filename','');
set(gcbf,'Visible','off');
nph = newPicture();
uiwait(nph);
set(gcbf,'Visible','on');

% --- Executes on button press in button_viewset.
function button_viewset_Callback(hObject, eventdata, handles)
% hObject    handle to button_viewset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%set(gcbf,'Visible','off');

csh = guiChooseSet();
uiwait(csh);

esh = guiExploreSet();
uiwait(esh);

%set(gcbf,'Visible','on');


% --- Executes on button press in button_batch.
function button_batch_Callback(hObject, eventdata, handles)
% hObject    handle to button_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
