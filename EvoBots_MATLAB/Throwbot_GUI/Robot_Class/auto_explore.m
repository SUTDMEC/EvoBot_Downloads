function [ ma, obst, c,c_obst ] = auto_explore( robot_h, robotNumber,mean_angle,prev,bot_num,thet_con,c,c_obst)
%auto_explore: Decide what command to send a robot. Points robot in
%direction where the IR sensor sees nothing
%   robot_h - send in the handle to RobotClass object
%   robotNumber - select which robot to control

ma=mean_angle;
obst=0;
durationT = 200;  %set duration of turn command
durationF = 300; %set duration of forward command
if thet_con==1
Kp=0.5;
%Rescale the angles to anticlk:+ve and clk:-ve
for kk=1:length(prev)
prev(kk)=wrapTo180(prev(kk));%wrap heading to 180
end

mean_angle=mean(prev);
if abs((prev(bot_num)-mean_angle))>1%if the difference between the robot's heading and the mean heading is more than 1
    delta_motors=Kp*(prev(bot_num)-mean_angle);%proportional control
else
    delta_motors=0;
end
left_mot=round(100+delta_motors);%keep 60% duty cycle as the base speed and vary the speed about this base speed
right_mot=round(100-delta_motors);
else left_mot=150;
    right_mot=150;
end
if robotNumber > robot_h.i  %if robotNumber is larger than number of selected robots
    robotNumber = 0;  %don't do anything 
else  %if robotNumber is acceptable, do stuff
    if thet_con==1
    cmd = [strcat('w',num2str(left_mot),';',num2str(right_mot),';', num2str(durationF), ';')];
    c(bot_num)=c(bot_num)+1;
    elseif thet_con==0
    cmd=['w150;150;' num2str(durationF)];
    c(bot_num)=c(bot_num)+1;
    end

    n = robotNumber; %use n instead of robotNumber to improve readablity
    IR = robot_h.data(n).ir_data; %get the IR data from robot
    
 
if thet_con==0||thet_con==1%remove thet_con==1 to not have obstacle avoidance in theta consensus mode
 %  check if front IR sees nothing (move fwd)
    if IR(2) == -1 || IR(2) > 300
%          %cmd = ['w100;100;' num2str(durationF) ';'];
%           cmd = ['w100;100;' num2str(durationT) ';'];
            if c(bot_num)<c_obst(bot_num)+3
                cmd = ['w150;150;' num2str(durationF) ';'];
                c(bot_num)=c(bot_num)+1;
            else
            cmd = [strcat('w',num2str(left_mot),';',num2str(right_mot),';', num2str(durationF), ';')];
            c(bot_num)=c(bot_num)+1;
            end

    %if side IR sensors see nothing, turn randomly
    elseif IR(1) == -1 && IR(3) == -1
        if rand > 0.5
            cmd = ['w-150;150;' num2str(durationT) ';'];
            ma=prev(bot_num)+90;
            obst=1;
            c(bot_num)=c(bot_num)+1;
            c_obst(bot_num)=c(bot_num);
        else
            cmd = ['w150;-150;' num2str(durationT) ';'];
            ma=prev(bot_num)-90;
            obst=1;
            c(bot_num)=c(bot_num)+1;
            c_obst(bot_num)=c(bot_num);
        end

    %if left IR sees nothing and right IR does, turn left
    elseif IR(1) == -1 && IR(3) ~=-1
        cmd = ['w-150;150;' num2str(durationT) ';'];
        ma=prev(bot_num)+90;
        obst=1;
        c(bot_num)=c(bot_num)+1;
        c_obst(bot_num)=c(bot_num);

    %if right IR sees nothing and left IR does, turn right
    elseif IR(1) ~= -1 && IR(3) == -1
        cmd = ['w150;-150;' num2str(durationT) ';'];
        ma=prev(bot_num)-90;
        obst=1;
        c(bot_num)=c(bot_num)+1;
        c_obst(bot_num)=c(bot_num);
    %left IR objects are closer than Ribht IR objects - turn right
    elseif IR(1) < IR(3)
        cmd = ['w150;-150;' num2str(durationT) ';'];
        ma=prev(bot_num)+90;
        obst=1;
        c(bot_num)=c(bot_num)+1;
        c_obst(bot_num)=c(bot_num);
    %turn left
    else
        cmd = ['w-150;150;' num2str(durationT) ';'];
        ma=prev(bot_num)-90;
        obst=1;
        c(bot_num)=c(bot_num)+1;
        c_obst(bot_num)=c(bot_num);
    end
end
  % write the command to robot
  
  %Remote control functionality: Uncomment the code below to control the
  %robot in remote control mode
%   bot_ip=input('5 for straight, 1 for left, 3 for right, 2 for back');
%   if bot_ip==5
%       cmd='w100;100;10000;';%move straight at full speed for 10 s
%   elseif bot_ip==2
%       cmd='w-100;-100;1000;';%move back at full speed for 1 s
%   elseif bot_ip==3
%       cmd='w100;50;1000;';%Turn right with right wheel at half speed
%   elseif bot_ip==1
%       cmd='w50;100;1000;';%Turn left with left wheel at half speed
%   else cmd='w100;100;1000;';%Move forward at max speed for 1s
%   end
%   n=robotNumber;
%     cmd=('w100;30;200;');
% v1=-30;
% v2=30;
%      cmd=strcat('w',num2str(round(50)),';',num2str(round(60)),';',num2str(durationF),';');
    robot_h.write(n,cmd);
%     toc
end
end

