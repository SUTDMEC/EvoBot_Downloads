function varargout = RobotGUI(varargin)
% ROBOTGUI MATLAB code for RobotGUI.fig
%      ROBOTGUI, by itself, creates a new ROBOTGUI or raises the existing
%      singleton*.
%
%      H = ROBOTGUI returns the handle to a new ROBOTGUI or the handle to
%      the existing singleton*.
%
%      ROBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTGUI.M with the given input arguments.
%
%      ROBOTGUI('Property','Value',...) creates a new ROBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotGUI

% Last Modified by GUIDE v2.5 15-Apr-2014 23:10:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RobotGUI_OpeningFcn, ...
    'gui_OutputFcn',  @RobotGUI_OutputFcn, ...
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


% --- Executes just before RobotGUI is made visible.
function RobotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotGUI (see VARARGIN)

% Choose default command line output for RobotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RobotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in manualexplore.
function manualexplore_Callback(hObject, eventdata, handles)
% hObject    handle to manualexplore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'m');


% --- Executes on button press in autoexplore.
function autoexplore_Callback(hObject, eventdata, handles)
% hObject    handle to autoexplore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pairbt.
function pairbt_Callback(hObject, eventdata, handles)
% hObject    handle to pairbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = serial('COM4');
pause(3);
fopen(s);
success=0;
'Connected'
handles.bt=s;
guidata(hObject,handles)



function SensCurr_Callback(hObject, eventdata, handles)
% hObject    handle to SensCurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensCurr as text
%        str2double(get(hObject,'String')) returns contents of SensCurr as a double


% --- Executes during object creation, after setting all properties.
function SensCurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensCurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensBV_Callback(hObject, eventdata, handles)
% hObject    handle to SensBV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensBV as text
%        str2double(get(hObject,'String')) returns contents of SensBV as a double


% --- Executes during object creation, after setting all properties.
function SensBV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensBV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensAccX_Callback(hObject, eventdata, handles)
% hObject    handle to SensAccX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensAccX as text
%        str2double(get(hObject,'String')) returns contents of SensAccX as a double


% --- Executes during object creation, after setting all properties.
function SensAccX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensAccX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hin   t: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','wfsthite');
end



function SensGyrX_Callback(hObject, eventdata, handles)
% hObject    handle to SensGyrX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensGyrX as text
%        str2double(get(hObject,'String')) returns contents of SensGyrX as a double


% --- Executes during object creation, after setting all properties.
function SensGyrX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensGyrX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensIRL_Callback(hObject, eventdata, handles)
% hObject    handle to SensIRL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensIRL as text
%        str2double(get(hObject,'String')) returns contents of SensIRL as a double


% --- Executes during object creation, after setting all properties.
function SensIRL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensIRL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensIRC_Callback(hObject, eventdata, handles)
% hObject    handle to SensIRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensIRC as text
%        str2double(get(hObject,'String')) returns contents of SensIRC as a double


% --- Executes during object creation, after setting all properties.
function SensIRC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensIRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensIRR_Callback(hObject, eventdata, handles)
% hObject    handle to SensIRR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensIRR as text
%        str2double(get(hObject,'String')) returns contents of SensIRR as a double


% --- Executes during object creation, after setting all properties.
function SensIRR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensIRR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in videostream.
function videostream_Callback(hObject, eventdata, handles)
% hObject    handle to videostream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
button_state = get(hObject,'Value');
i=1;
while(button_state)
    %disp('-----------------------------------------------------');
    name = strcat('ImageNumber',int2str(i),'.jpg');
    %disp (name);
    img=imread('http://ai-ball.com/?action=snapshot');
    imwrite(img,name);
    imshow(img);
    pause(0.05);
    i=i+1;
    button_state = get(hObject,'Value');
end

% --- Executes on button press in SLAMstart.
function SLAMstart_Callback(hObject, eventdata, handles)
% hObject    handle to SLAMstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fwd_button.
function fwd_button_Callback(hObject, eventdata, handles)
% hObject    handle to fwd_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'i');


% --- Executes on button press in bkwd_button.
function bkwd_button_Callback(hObject, eventdata, handles)
% hObject    handle to bkwd_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'k');


% --- Executes on button press in left_button.
function left_button_Callback(hObject, eventdata, handles)
% hObject    handle to left_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'j');

function SensAccY_Callback(hObject, eventdata, handles)
% hObject    handle to SensAccY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensAccY as text
%        str2double(get(hObject,'String')) returns contents of SensAccY as a double


% --- Executes during object creation, after setting all properties.
function SensAccY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensAccY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensAccZ_Callback(hObject, eventdata, handles)
% hObject    handle to SensAccZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensAccZ as text
%        str2double(get(hObject,'String')) returns contents of SensAccZ as a double


% --- Executes during object creation, after setting all properties.
function SensAccZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensAccZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensGyrY_Callback(hObject, eventdata, handles)
% hObject    handle to SensGyrY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensGyrY as text
%        str2double(get(hObject,'String')) returns contents of SensGyrY as a double


% --- Executes during object creation, after setting all properties.
function SensGyrY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensGyrY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SensGyrZ_Callback(hObject, eventdata, handles)
% hObject    handle to SensGyrZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SensGyrZ as text
%        str2double(get(hObject,'String')) returns contents of SensGyrZ as a double


% --- Executes during object creation, after setting all properties.
function SensGyrZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SensGyrZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetTime.
function SetTime_Callback(hObject, eventdata, handles)
% hObject    handle to SetTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
tset = datenum(clock);
fprintf(bt,'t');
handles.tset=tset;
guidata(hObject,handles)


% --- Executes on key press with focus on pairbt and none of its controls.
function pairbt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pairbt (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sensor_stream.
function sensor_stream_Callback(hObject, eventdata, handles)
% hObject    handle to sensor_stream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
fileID1 = fopen('hello.txt','w');
current_x_position=0;
current_y_position=0;
previous_x_position=0;
previous_y_position=0;
distance_x_moved=0;
distance_y_moved=0;
moved_x_outofscreen=0;
moved_y_outofscreen=0;
landmark_y_location=0;
landmark_x_location=0;
robot_orientation=90;
image_count = 1;

bt = handles.bt;
fprintf(bt,'s');
button_state = get(hObject,'Value');
fileID = fopen(strcat('sensor_data',datestr(now,'yy_mm_dd_HH_MM'),'.txt'),'wt');
fprintf(fileID,'Evobot Gen01 - Sensor Stream, Time Commenced:');
fprintf(fileID,datestr(handles.tset));
fprintf(fileID,'\n\r\n\rTime\tCurrent\tVoltage\tIR(Left)\tIR(Centre)\tIR(Right)\tAccX\tAccY\tAccY\tAccZ\tGyrX\tGyrY\tGyrZ\n\r');
while(button_state)
axes(handles.axes1);
    image_string = strcat('ImageNumber',int2str(image_count),'.jpg');
    if (exist(image_string, 'file') == 2)
        image = imread(image_string);
        imshow(image);
        image_count=image_count+1;
    end
    
    
    str=fscanf(bt);
    temp = strsplit(str,';');
    num = size(temp);
    pause(0.05);
    for i=2:num(2)-1
        val = strsplit(temp{i},'_');
        x = val{2};
        if(strcmp(val{1},'t'))
            seconds=str2num(val{2});
            st=datestr(addtodate(handles.tset,seconds,'second'),'HH:MM:SS');
            set(handles.Robot_Time,'string',st);
            data{1}=st;
        elseif(strcmp(val{1},'1'))
            set(handles.SensCurr,'string',x);
            data{2}=x;
        elseif(strcmp(val{1},'2'))
            set(handles.SensBV,'string',x);
            data{3}=x;
        elseif(strcmp(val{1},'3'))
            set(handles.SensAccX,'string',x);
            data{4}=x;
        elseif(strcmp(val{1},'4'))
            set(handles.SensAccY,'string',x);
            data{5}=x;
        elseif(strcmp(val{1},'5'))
            set(handles.SensAccZ,'string',x);
            data{6}=x;
        elseif(strcmp(val{1},'6'))
            set(handles.SensGyrX,'string',x);
            data{7}=x;
        elseif(strcmp(val{1},'7'))
            set(handles.SensGyrY,'string',x);
            data{8}=x;
        elseif(strcmp(val{1},'8'))
            set(handles.SensGyrZ,'string',x);
            data{9}=x;
        elseif(strcmp(val{1},'9'))
            set(handles.SensIRL,'string',x);
            data{10}=x;
        elseif(strcmp(val{1},'10'))
            set(handles.SensIRC,'string',x);
            data{11}=x;
        elseif(strcmp(val{1},'11'))
            set(handles.SensIRR,'string',x);
            data{12}=x;
        elseif(strcmp(val{1},'12'))
            set(handles.CurrentHeading,'string',x);
            data{13}=x;
        end
        
    end
    fprintf(fileID, '"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t"%s"\t\n', data{:});
    button_state = get(hObject,'Value');
    robot_orientation=90-str2num(data{13});
    flag_set = 0;
    screensize = get(0,'ScreenSize');
    coords = get(0,'PointerLocation');
    midpoint_xy = [screensize(3)/2 screensize(4)/2];
    axes(handles.axes2);
    if(coords(1) ~= 800 && coords(2) ~= 480)
        %set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]);
        rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
        rel_distancecm = [rel_distancematrix(1)/380 rel_distancematrix(2)/380];
        distance_x_moved=rel_distancematrix(1)/380-previous_x_position;
        distance_y_moved=rel_distancematrix(2)/380-previous_y_position;
        previous_x_position= rel_distancematrix(1)/380;
        previous_y_position= rel_distancematrix(2)/380;
        %current_x_position=previous_x_position+distance_x_moved+moved_x_outofscreen;
        %current_y_position=previous_y_position+distance_y_moved+moved_y_outofscreen;
        current_x_position=(rel_distancematrix(1)/380)*sind(robot_orientation)+(rel_distancematrix(2)/380)*cosd(robot_orientation)+moved_x_outofscreen
        current_y_position=(rel_distancematrix(2)/380)*sind(robot_orientation)+(rel_distancematrix(1)/380)*cosd(robot_orientation)+moved_y_outofscreen
        position = [current_x_position current_y_position];
        fprintf(fileID1,'%6.2f 12.8f\n',position);
        
        scatter((current_x_position),current_y_position)
        axis([-100 100 -100 100]);
        grid on;
        hold on;
        pause(0.008);
        fprintf(fileID1,'%4i\n',rel_distancecm);
        %distance = norm( rel_distancecm);
        %fprintf('Distance travelled: %4i',distance);
    end
    
    if(coords(1) == 1600 || coords(2) == 900 || coords(1)== 1 || coords(2) == 1 || coords(1) == 800 || coords(2) == 480)
        %coords = get(0,'PointerLocation');
        rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
        rel_distancecmtop = [rel_distancematrix(1)/380 rel_distancematrix(2)/380];
        moved_x_outofscreen=current_x_position;
        moved_y_outofscreen=current_y_position;
        %distance_top = norm( rel_distancecm);
        flag_set = 1;
        set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]);
    end
    
    coords2 = get(0,'PointerLocation');
    
    if(flag_set == 1 && coords2(1) ~= 800 && coords2(2) ~= 480)
        %coords = get(0,'PointerLocation');
        rel_distancematrix = [coords2(1)-midpoint_xy(1) coords2(2)-midpoint_xy(2)];
        rel_distancecmtopcontin = [rel_distancematrix(1)/380 rel_distancematrix(2)/380];
        rel_distancecmtcontin = rel_distancecmtop + rel_distancecmtopcontin;
        %fprintf(fileID,'%4i\n',rel_distancecmtcontin);
        %distance_topcontin = norm( rel_distancecm);
        %fprintf('Distance travelled total: %4i',distance_top+ distance_topcontin);
        
    end
    
    if(str2num(data{11})<32 && str2num(data{11})>25)
        current_y_position;
        landmark_y_location=current_y_position+str2num(data{11})*sind(robot_orientation)
        landmark_x_location=current_x_position+str2num(data{11})*cosd(robot_orientation)
        scatter((landmark_x_location),landmark_y_location)
    end
    
    if(str2num(data{10})<40 && str2num(data{10})>24)
        landmark_y_location=current_y_position+(str2num(data{10})*sind(robot_orientation+45))
        landmark_x_location=current_x_position+(str2num(data{10})*cosd(robot_orientation+45))
        scatter((landmark_x_location),landmark_y_location)
    end
     if(str2num(data{12})<40 && str2num(data{12})>24)
        landmark_y_location=current_y_position+(str2num(data{10})*sind(robot_orientation-45))
        landmark_x_location=current_x_position+(str2num(data{10})*cosd(robot_orientation-45))
        scatter((landmark_x_location),landmark_y_location)
    end
    axis([-100 100 -100 100]);
    grid on;
    hold on;
    pause(0.008);
end
fclose(fileID);
fclose(fileID1);



function Robot_Time_Callback(hObject, eventdata, handles)
% hObject    handle to Robot_Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Robot_Time as text
%        str2double(get(hObject,'String')) returns contents of Robot_Time as a double


% --- Executes during object creation, after setting all properties.
function Robot_Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Robot_Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in randomwalk.
function randomwalk_Callback(hObject, eventdata, handles)
% hObject    handle to randomwalk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of randomwalk
bt = handles.bt;
fprintf(bt,'r');


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf(handles.bt,'x');


% --- Executes on button press in IMUCalibrate.
function IMUCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to IMUCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in right_button.
function right_button_Callback(hObject, eventdata, handles)
% hObject    handle to right_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'l');


% --- Executes on button press in Speed25.
function Speed25_Callback(hObject, eventdata, handles)
% hObject    handle to Speed25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'1');



% --- Executes on button press in Speed50.
function Speed50_Callback(hObject, eventdata, handles)
% hObject    handle to Speed50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'2');



% --- Executes on button press in Speed75.
function Speed75_Callback(hObject, eventdata, handles)
% hObject    handle to Speed75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'3');



% --- Executes on button press in Speed100.
function Speed100_Callback(hObject, eventdata, handles)
% hObject    handle to Speed100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bt = handles.bt;
fprintf(bt,'4');


f
function CurrentHeading_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentHeading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentHeading as text
%        str2double(get(hObject,'String')) returns contents of CurrentHeading as a double


% --- Executes during object creation, after setting all properties.
function CurrentHeading_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentHeading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
