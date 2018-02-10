function varargout = guiSearch(varargin)
% GUISEARCH MATLAB code for guiSearch.fig
%      UI for searching pictures
%      Alan Schoen, 2014
%
%      GUISEARCH, by itself, creates a new GUISEARCH or raises the existing
%      singleton*.
%
%      H = GUISEARCH returns the handle to a new GUISEARCH or the handle to
%      the existing singleton*.
%
%      GUISEARCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISEARCH.M with the given input arguments.
%
%      GUISEARCH('Property','Value',...) creates a new GUISEARCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiSearch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiSearch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiSearch

% Last Modified by GUIDE v2.5 28-Sep-2014 16:57:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiSearch_OpeningFcn, ...
                   'gui_OutputFcn',  @guiSearch_OutputFcn, ...
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


% --- Executes just before guiSearch is made visible.
function guiSearch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiSearch (see VARARGIN)

% Choose default command line output for guiSearch
handles.output = hObject;

%get pic to use
handles.code1 = getappdata(0,'current_code');
if isempty(handles.code1)
    error('Please provde a picture code, "setappdata(0,''current_code'',__CODE__)"');
end

prog = getDataProgress(handles.code1);
if ~prog.spotFin
    disp('You need to mark this picture before you can look for matches');
    setappdata(0,'current_code',handles.code1);
    pth = placeToad;
    set(pth,'WindowStyle','modal');
    uiwait(pth);
end

handles.img1 = loadBasePicture(handles.code1);
imshow(handles.img1,'Parent',handles.axes1);
set(handles.text_pic1,'String',getLongInfo(handles.code1));
handles.spot1 = load([getPath(handles.code1) filesep 'spotFin.mat']);
imshow(handles.spot1.fin,'Parent',handles.axes3);
handles = displayid1(handles);

record_path = getPath(handles.code1);
if exist([record_path filesep 'compLucas.mat'],'file')
    handles.compLucas = load([record_path filesep 'compLucas.mat']);
    handles.compLucas = handles.compLucas.comps;
else
    handles.compLucas = struct('code',cell(1,0),'value',cell(1,0));
end

if exist([record_path filesep 'compHand.mat'],'file')
    handles.compHand = load([record_path filesep 'compHand.mat']);
    handles.compHand = handles.compHand.comps;
else
    handles.compHand = struct('code',cell(1,0),'value',cell(1,0));
end

handles = prepare_search(handles);
guidata(hObject,handles);
handles = update_matchbox(handles);

handles = notify_matched(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiSearch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiSearch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function handles = prepare_search(handles)
if get(handles.search_thisset, 'Value')
    cset = getSet(handles.code1);
    handles.to_search = getUsableCodes(getCodes(cset));

elseif get(handles.search_years, 'Value')
    nyears = str2double(get(handles.nyears,'String'));

    set_names = getAllSets();
    set_years = cellfun(@getSetYear, set_names);

    thisdate = getDates({handles.code1});
    
    thisyear = thisdate{1}(1);
    minyear = thisyear - nyears + 1;
    maxyear = thisyear;

    use_sets = set_names(ismember(set_years, minyear:maxyear));

    catcodes = cellfun(@getCodes, use_sets, 'UniformOutput', false);
    handles.to_search = getUsableCodes(horzcat(catcodes{:}));
end

%exclude comparisons that have already been made
luccodes = {handles.compLucas.code};
alreadydone = ismember(handles.to_search,luccodes);
handles.to_search = handles.to_search(~alreadydone);

search_message(handles);

guidata(gcf,handles);
handles = update_matchbox(handles);

guidata(gcf,handles);


function search_message(handles)
msgstr = sprintf('%d comparisons remaining',length(handles.to_search));
set(handles.text_remain,'String',msgstr);
if length(handles.to_search) > 500
    set(handles.text_takeawhile,'String',sprintf('(This could\ntake a while)'));
else
    set(handles.text_takeawhile,'String','');
end

function handles = update_matchbox(handles)

if length(handles.compLucas)<2
    set(handles.list_matches,'String',{});
    return;
end

[~,ord] = sort([handles.compLucas.value],'descend');
handles.compLucas = handles.compLucas(ord);
compLucas = handles.compLucas;
thisone = strcmp(handles.code1,{handles.compLucas.code});
compLucas(thisone) = [];

ntop = 20;
topcodes = {compLucas(1:min(ntop,length(compLucas))).code};
topcorrs = [compLucas(1:min(ntop,length(compLucas))).value];

box_text = cell(size(topcodes));
for i=1:length(topcodes)
    box_text{i} = boxString(topcodes{i},topcorrs(i));
end

set(handles.list_matches,'String',box_text);

handles.matchcodes = topcodes;

handles = list_matches_action(handles);



function string = boxString(code, corr)
record_path = getPath(code);
photodata = load([record_path,filesep,'photodata.mat']);
idstr = 'No toad ID';
if photodata.toadid>0
    idstr = sprintf('%s-%d',photodata.toadidset,photodata.toadid);
end
string = sprintf('%.2f: %s (%s)',corr, idstr,datestr(photodata.date,'mm/dd/yyyy'));

% --- Executes on selection change in list_matches.
function list_matches_Callback(hObject, eventdata, handles)
noptions = length(get(hObject,'String'));

handles.code2 = '';

if noptions>0
    select = get(hObject,'Value');
    handles.code2 = handles.matchcodes{select};
    handles = showpic2(handles);
    guidata(hObject, handles);
end

function handles = list_matches_action(handles)
noptions = length(get(handles.list_matches,'String'));
handles.code2 = '';
if noptions>0
    select = get(handles.list_matches,'Value');
    handles.code2 = handles.matchcodes{select};
    handles = showpic2(handles);
end

function handles = showpic2(handles)
handles.img2 = loadBasePicture(handles.code2);
imshow(handles.img2,'Parent',handles.axes2);
set(handles.text_pic2,'String',getLongInfo(handles.code2));
handles.spot2 = load([getPath(handles.code2) filesep 'spotFin.mat']);
imshow(handles.spot2.fin,'Parent',handles.axes4);

handles = displayid2(handles);


% --- Executes during object creation, after setting all properties.
function list_matches_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_matches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_match.
function button_match_Callback(hObject, eventdata, handles)
if ismember(handles.code2,{handles.compHand.code})
    ind = strcmp(handles.code2,{handles.compHand.code});
    handles.compHand(ind) = [];
end
handles.compHand(end+1) = struct('code',handles.code2,'value',true);
photodata1 = load([getPath(handles.code1) filesep 'photodata.mat']);
photodata2 = load([getPath(handles.code2) filesep 'photodata.mat']);

set1 = getSet(handles.code1);
set2 = getSet(handles.code2);

%check if picture 2 has an id
id2 = photodata2.toadid;
if id2>0
    photodata1.toadid = id2;
    photodata1.toadidset = photodata2.toadidset;
    record_path = getPath(handles.code1);
    save([record_path filesep 'photodata.mat'],'-struct','photodata1');
end

handles = displayid1(handles);
handles = notify_matched(handles);
guidata(hObject,handles);

comps = handles.compHand;
record_path = getPath(handles.code1);
save([record_path filesep 'compHand.mat'],'comps');

% --- Executes on button press in button_fail.
function button_fail_Callback(hObject, eventdata, handles)
if ismember(handles.code2,{handles.compHand.code})
    ind = strcmp(handles.code2,{handles.compHand.code});
    handles.compHand(ind) = [];
end
handles.compHand(end+1) = struct('code',handles.code2,'value',false);
handles = notify_matched(handles);
guidata(hObject,handles);

comps = handles.compHand;
record_path = getPath(handles.code1);
save([record_path filesep 'compHand.mat'],'comps');


function nyears_Callback(hObject, eventdata, handles)
handles = prepare_search(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function nyears_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nyears (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button_search.
function button_search_Callback(hObject, eventdata, handles)
%THERE IS A PROBLEM HERE
%matchcodes not matching matchbox
handles = prepare_search(handles);
to_search = handles.to_search;

[corrs,progress] = searchLimited({handles.code1}, to_search);

newcorrs = struct('code',to_search(progress),'value',num2cell(corrs(progress)));

handles.compLucas = [handles.compLucas newcorrs];
handles.to_search = to_search(~progress);

handles = update_matchbox(handles);
search_message(handles)

guidata(hObject,handles);

comps = handles.compLucas;
record_path = getPath(handles.code1);
save([record_path filesep 'compLucas.mat'],'comps');

function cancel_search(hObject,eventdata,handles)
fh = gcbf;
setappdata(fh,'canceling',true);
%delete(fh);


%display id on first picture
function handles = displayid1(handles)
if isfield(handles,'ax1text')&&ishandle(handles.ax1text)
    delete(handles.ax1text);
    handles.ax1text = [];
end

photodata = load([getPath(handles.code1) filesep 'photodata.mat']);
toadid = photodata.toadid;

if toadid > 0
    set(handles.axes1,'Units','inches');
    axpos = get(handles.axes1,'position');
    handles.ax1text = text(0,axpos(4)-0.15,[photodata.toadidset '-' num2str(toadid)],'Parent',handles.axes1,'color','w','FontSize',26,'Units','inches');
end

%display id on second picture
function handles = displayid2(handles)
if isfield(handles,'ax2text')&&ishandle(handles.ax2text)
    delete(handles.ax2text);
    handles.ax2text = [];
end

if isfield(handles,'code2');

    photodata = load([getPath(handles.code2) filesep 'photodata.mat']);
    toadid = photodata.toadid;
    
    if toadid > 0
        set(handles.axes2,'Units','inches');
        axpos = get(handles.axes2,'position');
        axes(handles.axes2);
        handles.ax2text = text(0,axpos(4)-0.15,[photodata.toadidset '-' num2str(toadid)],'Color','w','FontSize',26,'Units','inches');
    end

end

% --- Executes when selected object is changed in search_panel.
function search_panel_SelectionChangeFcn(hObject, eventdata, handles)
handles = prepare_search(handles);
guidata(hObject,handles);


% --- Executes on button press in button_newtoad.
function button_newtoad_Callback(hObject, eventdata, handles)
% hObject    handle to button_newtoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parts = regexp(handles.code1,'#','split','once');
current_set = parts{1};

project_path = getappdata(0,'project_path');
if exist([project_path filesep 'Data' filesep current_set filesep 'setinfo.mat'],'file')
    setinfo = load([project_path filesep 'Data' filesep current_set filesep 'setinfo.mat']);
    setinfo.last_toad_no = setinfo.last_toad_no +1;
else
    setinfo.last_toad_no = 1;
end

photodata = load([getPath(handles.code1) filesep 'photodata.mat']);
photodata.toadid = setinfo.last_toad_no;
photodata.toadidset = current_set;
save([getPath(handles.code1) filesep 'photodata.mat'],'-struct','photodata');
save([project_path filesep 'Data' filesep current_set filesep 'setinfo.mat'],'-struct','setinfo');

handles = displayid1(handles);
guidata(hObject,handles);

function handles = notify_matched(handles)
if isfield(handles,'matched_handle')&&ishandle(handles.matched_handle)
    delete(handles.matched_handle);
    handles = rmfield(handles,'matched_handle');
end

if any([handles.compHand.value])
    handles.matched_handle = text(0,0.3,'(Matched!)','Parent',handles.axes1,'color','r','FontSize',26,'Units','inches');
end
