function varargout = selectRobotGUI(varargin)
% SELECTROBOTGUI MATLAB code for selectRobotGUI.fig
%      SELECTROBOTGUI by itself, creates a new SELECTROBOTGUI or raises the
%      existing singleton*.
%
%      H = SELECTROBOTGUI returns the handle to a new SELECTROBOTGUI or the handle to
%      the existing singleton*.
%
%      SELECTROBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTROBOTGUI.M with the given input arguments.
%
%      SELECTROBOTGUI('Property','Value',...) creates a new SELECTROBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectRobotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectRobotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectRobotGUI

% Last Modified by GUIDE v2.5 06-Aug-2014 18:58:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectRobotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @selectRobotGUI_OutputFcn, ...
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

% --- Executes just before selectRobotGUI is made visible.
function selectRobotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectRobotGUI (see VARARGIN)

% Choose default command line output for selectRobotGUI
handles.output = 'Yes';

%MARK added the handles
%if a robot function was passed in, save it into a handle
if size(varargin) > 0
    handles.Robot_h = varargin{1,1};        %ROBOTCLASS
else
    handles.Robot_h = -1; %indicate that there is no connected robot object
end
handles.IDs = 0;   
%END handles mark added

% Update handles structure
guidata(hObject, handles);

assignin('base','gui_h',handles); %(TODO comment out this line)

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.mainTitle, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

% Img=image(IconData, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', IconCMap);

% set(handles.axes1, ...
%     'Visible', 'off', ...
%     'YDir'   , 'reverse'       , ...
%     'XLim'   , get(Img,'XData'), ...
%     'YLim'   , get(Img,'YData')  ...
%     );

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes selectRobotGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = selectRobotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in ConnectButton.
function ConnectButton_Callback(hObject, eventdata, handles)
% hObject    handle to ConnectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.output = get(hObject,'String');
handles.output = get(handles.AddID_inputField,'String');

% Update handles structure
guidata(hObject, handles);

%call connect robots
%if RobotClass was passed in, use AddID function
if handles.Robot_h ~= -1
    handles.Robot_h.connectRobots;              %ROBOTCLASS
end

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
%     handles.output = 'No';
    handles.output = get(handles.AddID_inputField,'String');

    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    



function AddID_inputField_Callback(hObject, eventdata, handles)
% hObject    handle to AddID_inputField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AddID_inputField as text
%        str2double(get(hObject,'String')) returns contents of AddID_inputField as a double




% --- Executes during object creation, after setting all properties.
function AddID_inputField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AddID_inputField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%read from the 'AddID_inputField', save in temp 
temp{1} = get(handles.AddID_inputField,'String');

%if RobotClass was passed in, use AddID function
if handles.Robot_h ~= -1
    %add the next robot ID to robot class
    handles.Robot_h.addID(temp{1});         %ROBOTCLASS
    %for each robot, add name to the display
    for i = 1:handles.Robot_h.i
        temp{i} = handles.Robot_h.robot_ids{i};  %ROBOTCLASS
    end
end
handles.IDs = temp;

set(handles.RobotNameList,'String',handles.IDs)
guidata(hObject, handles);


% --- Executes on button press in RemoveAllbutton.
function RemoveAllbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveAllbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.RobotNameList,'String','');
if handles.Robot_h ~= -1  %check for robot class handle  %ROBOTCLASS
    handles.Robot_h.removeID;                            %ROBOTCLASS
end

% --- Executes on button press in Removebutton.
function Removebutton_Callback(hObject, eventdata, handles)
% hObject    handle to Removebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp{1} = get(handles.AddID_inputField,'String');
if handles.Robot_h ~= -1  %check for robot class handle
    %remove the selected robot ID
    handles.Robot_h.removeID(temp{1});
    %for each robot, add name to the display
    for i = 1:handles.Robot_h.i
        temp{i} = handles.Robot_h.robot_ids{i};
    end
end
%display the robot IDS in the list
set(handles.RobotNameList,'String',handles.IDs);
guidata(hObject, handles); %save changes to gui handles
