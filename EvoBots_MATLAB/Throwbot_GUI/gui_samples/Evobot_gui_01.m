function Evobot_gui_01(varargin)
%This code is for the GUI used to control the robot and plot stuff
%Written by Mark VanderMeulen. Contact me at vandermeulen@sutd.edu.sg

%Create and hide the GUI

%map contains the object detection and path history of robot. Add a button
%to include/exclude path history of robot.
map = figure('Visible','off','Position',[360,400,512,256]);

%"battery" shows a slider with the voltage or charge level of
%battery
%battery = figure('Visible','off','Position',[360,500,100,258])

%construct the components
hpathHistory = uicontrol('Style','checkbox','String','Path',...
            'Position',[335,225,70,15],...
       'Callback',{@pathbutton_Callback});
hscatter = uicontrol('Style','pushbutton','String','Scatter',...
        'Position',[315,120,70,25],...
        'Callback',{@scatterbutton_Callback});
hpopup = uicontrol('Style','popupmenu',...
           'String',{'Robot 1','Robot 2','Robot 3'},...
           'Position',[260,220,70,25],...
           'Callback',{@popup_menu_Callback});
       
ha = axes('Units','pixels','Position',[50,60,200,185]);
        
current_data = varargin{1}
current_data = current_data.x

set(map,'Visible','on');

% varargout = handle

    function pathbutton_Callback(source,eventdata)
        %Toggle between the robot's position or something like that
        
        path_data = 0;
    end

function popup_menu_Callback(source,eventdata) 
  % Determine the selected data set.
  str = get(source, 'String');
  val = get(source,'Value');
  % Set current data to the selected data set.
  switch str{val};
  case 'Robot 1' % User selects Peaks.
     current_data = varargin{1}.x;
  case 'Robot 2' % User selects Membrane.
     current_data = varargin{1}.x;
  case 'Robot 3' % User selects Sinc.
     current_data = varargin{1}.x;
  end
end

    function scatterbutton_Callback(source,eventdata)
        %Display surface
        current_data = varargin{1}.x;
        scatter(current_data{1},current_data{2});
    end

end