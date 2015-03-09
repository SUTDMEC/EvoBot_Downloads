function Evobot_gui_01= Evobot_mygui(hObject, eventdata, handles, varargin)
%This code is for the GUI used to control the robot and plot stuff
%Written by Mark VanderMeulen. Contact me at vandermeulen@sutd.edu.sg

%Create and hide the GUI

%map contains the object detection and path history of robot. Add a button
%to include/exclude path history of robot.
handles.map = figure('Visible','off','Position',[360,400,512,256]);

%"battery" shows a slider with the voltage or charge level of
%battery
%battery = figure('Visible','off','Position',[360,500,100,258])
handles.command = 0;
%construct the components
handles.hpathHistory = uicontrol('Style','checkbox','String','Path',...
            'Position',[335,225,70,15],...
       'Callback',{@pathbutton_Callback});
handles.exit = uicontrol('Style','togglebutton','String','Exit',...
        'Position',[345,120,70,25],...
        'Callback',{@Exitbutton_Callback});
handles.manual_ctrl = uicontrol('Style','togglebutton','String','Manual Ctrl',...
        'Position',[345,50,70,25],...
        'Callback',{@manual_ctrl_Callback});
handles.fwd = uicontrol('Style','pushbutton','String','Fwd',...
        'Position',[345,25,50,25],...
        'Callback',{@Fwd_ctrl_Callback});
handles.stop = uicontrol('Style','pushbutton','String','Stop',...
        'Position',[345,00,50,25],...
        'Callback',{@Stop_ctrl_Callback});
handles.left = uicontrol('Style','pushbutton','String','Left',...
        'Position',[295,00,50,25],...
        'Callback',{@Left_ctrl_Callback});
handles.right = uicontrol('Style','pushbutton','String','Right',...
        'Position',[395,00,50,25],...
        'Callback',{@Right_ctrl_Callback});
handles.hpopup = uicontrol('Style','popupmenu',...
           'String',{'Robot 1','Robot 2','Robot 3'},...
           'Position',[260,220,70,25],...
           'Callback',{@popup_menu_Callback});
       
handles.ha = axes('Units','pixels','Position',[50,60,200,185]);
        
% current_data = varargin{1};
% current_data = varargin{1}.map.robot_path;
MyStructHere = evalin('base','Map_Data');
handles.MyStructHere = MyStructHere;
DataHere = MyStructHere.imu_state;
current_data = MyStructHere.imu_state;



% 'disp(''timer'')',
handles.t = timer('TimerFcn',  'myfunct1' ,....% hObject, eventdata, handles',...%'{scatterbutton2_Callback}',...
'ExecutionMode','fixedRate','Period',0.5,'StartDelay',1);
% handles.plot = plot(map,current_data(1),current_data(2))
handles.output = hObject;
guidata(handles.map,handles);

assignin('base','Gui_Handles',handles)

set(handles.map,'Visible','on');

% varargout = handle
    Evobot_gui_01.myFunc = @myfunct1;
    function pathbutton_Callback(source,eventdata)
        %Toggle between the robot's position or something like that
        
        path_data = 0;
    end

    function update()
        
    end
    function Fwd_ctrl_Callback(source,eventdata)
        handles.command = 1;
    end
    function Stop_ctrl_Callback(source,eventdata)
        handles.command = 0;
    end
    function Left_ctrl_Callback(source,eventdata)
        handles.command = 2;
    end
    function Right_ctrl_Callback(source,eventdata)
        handles.command = 3;
    end
function popup_menu_Callback(source,eventdata) 
  % Determine the selected data set.
  str = get(source, 'String');
  val = get(source,'Value');
  % Set current data to the selected data set.
  switch str{val};
  case 'Robot 1' % User selects Peaks.
     current_data = MyStructHere.imu_state;
  case 'Robot 2' % User selects Membrane.
     current_data = MyStructHere.imu_state;
  case 'Robot 3' % User selects Sinc.
     current_data = MyStructHere.imu_state;
  end
end

    function Exitbutton_Callback(source,eventdata)
        handles.command = -1;
    end

    function plot_stuff(source,eventdata)
        handles=guidata(hObject);
    
        current_data = MyStructHere.imu_state;
        scatter(handles.ha,current_data(1),current_data(2));
        
        guidata(hObject,handles);
    end

end