function varargout = basicRobotCtrl(varargin)
% BASICROBOTCTRL MATLAB code for basicRobotCtrl.fig
%      BASICROBOTCTRL, by itself, creates a new BASICROBOTCTRL or raises the existing
%      singleton*.
%
%      H = BASICROBOTCTRL returns the handle to a new BASICROBOTCTRL or the handle to
%      the existing singleton*.
%
%      BASICROBOTCTRL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASICROBOTCTRL.M with the given input arguments.
%
%      BASICROBOTCTRL('Property','Value',...) creates a new BASICROBOTCTRL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before basicRobotCtrl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to basicRobotCtrl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help basicRobotCtrl

% Last Modified by GUIDE v2.5 07-Aug-2014 01:57:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @basicRobotCtrl_OpeningFcn, ...
                   'gui_OutputFcn',  @basicRobotCtrl_OutputFcn, ...
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

% --- Executes just before basicRobotCtrl is made visible.
function basicRobotCtrl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to basicRobotCtrl (see VARARGIN)

% Choose default command line output for basicRobotCtrl
handles.output = hObject;

%MARK added these handles
if size(varargin) > 0
    handles.Robot_h = varargin{1}%,1};  %ROBOTCLASS
else
    handles.Robot_h = -1; %indicate that there is no connected robot object
end
handles.IDs = 0;  %contains list of robot id's from robot class
handles.popup_sel_index = 1; %contains selected robot index


% % Initialize timer to update the map regularly
% handles.timer = timer(...
%     'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
%     'Period', 1, ...                % Initial period is 0.2 sec.
%     'TimerFcn', {@update_display,hObject}); % Specify callback

handles.update_flag = 0; %stop updating the map when this is 0
%/MARKS's handles

% Update handles structure
guidata(hObject, handles);
assignin('base','gui_h',handles); %(TODO comment out this line)

% This sets up the initial plot - only do when we are invisible
% so window can get raised using basicRobotCtrl.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes basicRobotCtrl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = basicRobotCtrl_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
delete(handles.figure1)


% --- Executes on selection change in robot_select.
function robot_select_Callback(hObject, eventdata, handles)
% hObject    handle to robot_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns robot_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from robot_select
%get the selected robot number from popup menu
contents = get(hObject,'Value');
handles.Robot_h.selected = contents;

% --- Executes during object creation, after setting all properties.
function robot_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end




function user_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to user_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of user_cmd as text
%        str2double(get(hObject,'String')) returns contents of user_cmd as a double

%save the user input string to a handle
handles.str = get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function user_cmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sendButton.
function sendButton_Callback(hObject, eventdata, handles)
% hObject    handle to sendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the input string from edit window
tempstr = get(handles.user_cmd,'String');
%write the input string to the robot
if handles.Robot_h ~= -1
    %write(selectedrobotnumber,string)
    handles.Robot_h.write(tempstr); %ROBOTCLASS
end
handles.str = tempstr;


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startbutton
temp{1} = '';  %temporary variable to store robot IDs
%get the robot IDS from the robot handle
%if RobotClass was passed in, read robot ids
if handles.Robot_h ~= -1
    %for each robot, add name to the display
    for i = 1:handles.Robot_h.i
        temp{i} = handles.Robot_h.robot_ids{i};  %ROBOTCLASS
    end
end
handles.IDs = temp;


%Save the handle IDs into the popup menu
set(handles.robot_select, 'String', temp);
set(hObject,'Visible','Off');
% Update handles structure
guidata(hObject, handles);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% START USER CODE
% Necessary to provide this function to prevent timer callback
% from causing an error after GUI code stops executing.
% Before exiting, if the timer is running, stop it.
if strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
end
% Destroy timer
delete(handles.timer)
% END USER CODE

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.map_window);
cla;

%get selected value from popup menu
handles.popup_sel_index = get(handles.robot_select, 'Value');
%save this value into the robot class to define which robot to monitor
handles.Robot_h.selected = handles.popup_sel_index;     %ROBOTCLASS

%start the timer
% start(handles.timer);  %TODO: make this timer work
%make the stop button visible, and update invisible
set(handles.stopbutton,'Visible','on');
set(handles.updateButton,'Visible','off');

%reset the stop flag to zero
handles.update_flag = 1; 
% Update handles structure
guidata(hObject, handles);

%set the map update flag to zero - start updating map
handles.Robot_h.map_update_flag = 1;
% a = 0;
% while 1
%     a = a + 1
%     pause(1);
%     stat = get(handles.updateButton,'update_flag');
%     if stat ~= 1
%         break
%     end
% end
%keep looping until the stopbutton has been pressed

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%hide the 'stop' button, and update button visible
set(hObject,'Visible','Off');
set(handles.updateButton,'Visible','on');
%stop the timer from updating the map
% stop(handles.timer); %TODO make timer work
handles.update_flag = 0;

%set the map update flag to zero - stop updating map
handles.Robot_h.map_update_flag = 0;
% set(handles.updateButton,'update_flag',0);
% Update handles structure
guidata(hObject, handles);






% START USER CODE (for timer callback) <THIS IS NOT WORKING>
function update_display(hObject,eventdata,hfigure)
% Timer timer1 callback, called each time timer iterates.
% Gets surface Z data, adds noise, and writes it back to surface object.


handles = guidata(hfigure);
map_handle = handles.map_window;
if handles.Robot_h ~= -1
    handles.Robot_h.Update_Map(map_handle);
end

% Z = get(handles.surf,'ZData');
% Z = Z + 0.1*randn(size(Z));
% set(handles.surf,'ZData',Z);
% END USER CODE
