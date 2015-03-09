%This file works a bit for one robot
%Try running 'Robot_Script' instead

%create an array of RobotCom objects
% Initialize robots
% send '&' and '?' to verify that the robot is connected
% while(1) update with the RobotCom to get all the data from robots

addpath('Libraries') %include path for robot classes and subclasses
addpath('Libraries/mini_GUIs');

Rclean; %clean up everything in workspace

ss = 'Evobot_01';  %create name for robot
x = RobotClass;    %create robot object
% x.addID(ss);

%open robot selection GUI, pass the ROBOTCLASS object in
selectRobotGUI(x);

%set the filepath where all data should be stored
x.set_savepath('Z:\Temasek Laboratories\STARS\sensorData\'); %save to Z drive
% x.set_savepath('C:\Users\Abhishek\Downloads\New folder\');  %for mark's testing

%create files for saving data into
for i = 1:x.i
    x.data(i).create_file
end

%open basic robot command GUI
basicRobotCtrl(x);
while x.map_update_flag ==0
    pause(1)
end

%You must write these two commands when you first connect to the robot
for i = 1:x.i
    x.write(i,'&');  %send command character to enter machine interface
    pause(0.1);
    x.write(i,'w100;100;100;'); %send this command so the robot will start sending data
end
x.update;
pause(0.1);
x.calibrate();     %calibrate robot (only does YAW)
%You MUST calibrate. More specifically you MUST call
%x.data(i).odometry_reset to create a new RobotMap handle (TODO: FIX THIS
%BUG)


fprintf('Calibration complete')


m(1) = figure('Position', [10,350,400,400]); %open figure for map
m(2) = figure('Position', [430,350,400,400]);
m(3) = figure('Position', [850,350,400,400]);
p(1) = figure('Position', [10,50,400,200]); %open figure for power
p(2) = figure('Position', [430,50,400,200]);
p(3) = figure('Position', [850,50,400,200]);

for i = 1:x.i
    set(m(i),'Name', ['Map ' x.robot_ids{i}]);
    set(p(i),'Name', ['Power ' x.robot_ids{i}]);
end

count = 0;
n = 1;
power = 0;
time = 0;
while x.map_update_flag == 1
    count = count + 1   %display this counter - show that program is running
    x.update;  %collect data from robot, process it
    
    for i = 1:3  %save the power used at each moment in time
        if i <= x.i  %only do this if i is <= number of robots
            power(i,n) = x.data(i).power;  %collect power usage from robot
            time(i,n)  = x.data(i).time;   %collect timestamp from robot
        else
            power(i,n) = n;
            time(i,n) = n;
        end
    end
    n = n+1; %increment counter
    
    
    for i = 1:3  %check if robot is stopped. If so, use auto_explore
        if i <= x.i  %only run if i<= number of robots
            if x.stop_flag(i) == 1
                auto_explore(x,i)
                x.stop_flag(i) = 0;
            end
        end
    end
    pause(0.01); %add a short pause so you can interrupt program if need be
    if count >= 100  %only update figures every 100 datapoints
        %plot maps (use sfigure instead of figure so it doesn't pop to front)
        sfigure(m(1));
        x.Update_Map(1);  %IMPLEMENT WITH GUI: call x.Update_Map(robotNumber,map_handle)
        sfigure(m(2));
        x.Update_Map(2);
        sfigure(m(3));
        x.Update_Map(3);
        
        %plot power
        sfigure(p(1));
        l = length(time);  %only plot the last 200 datapoints
        if l <=200  %if less than 200 datapoints, plot all
            scatter(time(1,:),power(1,:));
            sfigure(p(2));
            plot(time(2,:),power(2,:));
            sfigure(p(3));
            plot(time(3,:),power(3,:));
        else
            scatter(time(1,l-200:l),power(1,l-200:l));
            sfigure(p(2));
            plot(time(2,l-200:l),power(2,l-200:l));
            sfigure(p(3));
            plot(time(3,l-200:l),power(3,l-200:l));
        end
        pause(1)
        count = 1; %reset counter
    end
end
close(m(1),m(2),m(3)) %close all figures
close(p(1),p(2),p(3)) %close all figures
%x.close_savefiles %close files where robot data is saved to.


% %delete(x);
fprintf('\nEnded demo')