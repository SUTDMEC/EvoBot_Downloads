%This file works a little bit for one robot
%Try running 'Robot_Script' instead

%create an array of RobotCom objects
% Initialize robots
% send '&' and '?' to verify that the robot is connected
% while(1) update with the RobotCom to get all the data from robots

addpath('Libraries') %include path for robot classes and subclasses
% addpath('Libraries/mini_GUIs');
Rclean; %clean up everything

MyStruct.data = [1 2];
MyStruct.otherData = [2 4];

ss = 'Evobot_01';  %create name for robot
x = RobotClass;    %create robot object
% x.RobotClasss;
x.addID(ss);       %add robot ID
x.sendToWorkspace;

x.bt.connect;      %connect to all robots (must use x.addID for each robot)
x.write(1,'&');  %send command character to enter machine interface

x.write(1,'A');
x.write(1,'A');
x.write(1,'A');
x.calibrate();     %calibrate robot

% pause(0.5);
% x.bt.write_cmd('w110;110;1000;');
% pause(1);
status = 1;
count = 0;
x.write(1,'w100;100;1000;'); %command to drive robot forward
while(count < 250)
   % x.write(1,'A');
    status = x.update;
    stringy = x.bt.str;
%     fprintf(stringy)

        count = count + 1;
        if(Gui_Handles.command < 0)
            count = 250;
            break
        end
end
x.data
%delete(x);
fprintf('Ended demo')