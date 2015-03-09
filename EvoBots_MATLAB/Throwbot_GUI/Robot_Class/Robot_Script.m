function Robot_Script(log_path, bt, t_end,thet_con,traj_cont,rc,pos)

%This file works a little bit for multiple robot
%Try running 'Robot_Script' instead

%create an array of RobotCom objects
% Initialize robots
% send '&' and '?' to verify that the robot is connected
% while(1) update with the RobotCom to get all the data from robots

addpath('Libraries') %include path for robot classes and subclasses
addpath('Libraries/mini_GUIs');

% Rclean; %clean up everything in workspace

%START OF NEW ATTEMPT
s = bt;
robot_num = length(bt);

for i = 1:robot_num  
    x(i) = RobotClass;  %create robot object
    x(i).addID( s(i).remotename, s(i),i); %add robot IDs
    x(i).connectRobots; %connect all robots
    x(i).set_savepath(log_path);  %for mark's testing
    x(i).data(1).create_file;
end

%open basic robot command GUI
basicRobotCtrl(x(1));

%You must write these two commands when you first connect to the robot.
%This is done to calibrate the robots. Each robot has its own calibration
%parameters
for i = 1:robot_num
    x(i).write(1,'&');  %send command character to enter machine interface
    pause(0.1);
    if strcmp(s(i).remotename,'Evobot_30')
        x(i).write(1,'M100;96;');
        x(i).write(1,'k7333;8037;30000;');
    elseif strcmp(s(i).remotename,'Evobot_10')
        x(i).write(1,'M100;98;');
        x(i).write(1,'k8200;9000;30000;');
    elseif strcmp(s(i).remotename,'Evobot_01')
        x(i).write(1,'M100;99;');
        x(i).write(1,'k7750;8500;30000;');
    elseif strcmp(s(i).remotename,'Evobot_211')||strcmp(s(i).remotename,'Evobot_21')
        x(i).write(1,'M100;98;');
        x(i).write(1,'k8650;9475;30000;');
    elseif strcmp(s(i).remotename,'Evobot_08')
        x(i).write(1,'M100;97;');
        x(i).write(1,'k9500;10400;30000;');
    elseif strcmp(s(i).remotename,'Evobot_03')
        x(i).write(1,'M97;100;');
        x(i).write(1,'k10100;11050;30000;');
    elseif strcmp(s(i).remotename,'Evobot_11')
        x(i).write(1,'M100;92;');
        x(i).write(1,'k5000;5000;30000;');
        
    end
    
    
    %move robot ahead for 300 milliseconds
%     x(i).write(1,'w100;100;300;'); %send this command so the robot will start sending data
    x(i).update;
%     pause(0.1);
    %calibrate the yaw from the IMU
    x(i).calibrate();     %calibrate robot (only does YAW)
   
end

%You MUST calibrate. More specifically you MUST call
fprintf('Calibration complete')
for i = 1:1%robot_num
%m = figure('Position', [10+(420*(i-1)),350,400,400]); %open figure for map
p = figure;%('Position', [10+(420*(i-1)),50,400,200]); %open figure for power
hold on
end
if thet_con==0%0
for i = 1:1%robot_num
    set(p,'Name', ['Environment Map']);% x(i).robot_ids{1}]);
end
end

count = 0;
n = 1;
power = 0;
time = 0;
c_obst=zeros(1,robot_num);%[0 0 0 ];
c=zeros(1,robot_num);%[0 0 0];
ekf_count=ones(1,robot_num);
for i=1:robot_num
P{i}=eye(5);
state_x{i}=zeros(5,1);
theta_hist{i}=[];
error_hist{i}=[];
prev_tic_R(i)=x(i).data.column(14)/10600;
prev_tic_L(i)=x(i).data.column(13)/10600;
vel_hist=[];
cnt=1;
end
t1=zeros(1,robot_num);
t2=t1;
Ts=t1;
v1=0;
v2=0;
start_time=now*ones(1,robot_num);

while now<(t_end)%+15/60/60/24)
 
    count = count + 1;   %display this counter - show that program is running
    

    for i = 1:robot_num
        t1(i) = x(i).data.column(1);
        x(i).update;  %collect data from robot, process it
        t2(i) = x(i).data.column(1);
        Ts(i)=(t2(i)-t1(i))/1000;
    end

    
    
    for i = 1:robot_num  %save the power used at each moment in time
        if i <= robot_num  %only do this if i is <= number of robots
            power(i,n) = x(i).data(1).power;  %collect power usage from robot
            time(i,n)  = x(i).data(1).time;   %collect timestamp from robot
        else
            power(i,n) = n;
            time(i,n) = n;
        end
%     end
    n = n+1; %increment counter
    
    
    if count==1
        for j=1:robot_num
        initial_heading(j)=x(j).data.column(9);
        save initial_heading initial_heading
        end
    end
       
    load initial_heading
    
    for kk=1:robot_num
        prev(kk)=x(kk).data.column(9)-initial_heading(kk);
    end
    if Ts(i)>0
            if ekf_count(i)==1
                thet_initial(i)=deg2rad(x(i).data.column(9))-pos{i}(3);
            end
            optData.d_x=x(i).data.column(10);
            optData.d_y=x(i).data.column(11);
            current_tic_L(i)=x(i).data.column(13)/10600;
            current_tic_R(i)=x(i).data.column(14)/10600;
            enc_vel_L(i)=(current_tic_L(i)-prev_tic_L(i))/Ts(i);
            enc_vel_R(i)=(current_tic_R(i)-prev_tic_R(i))/Ts(i);
            prev_tic_L(i)=current_tic_L(i);
            prev_tic_R(i)=current_tic_R(i);
            
            theta_hist{i}=[theta_hist{i} (deg2rad(x(i).data.column(9)))-(thet_initial(i))];
            theta_hist{i}=unwrap(theta_hist{i});
            
            if ekf_count(i)<=1
                d_theta=0;
            else
                d_theta=theta_hist{i}(end)-theta_hist{i}(end-1);
            end
            [opt_vel_1, opt_vel_2]=mouseVel(optData,d_theta,Ts(i),49/1000);
%             [enc_vel_1, enc_vel_2]=mouseVel(encData,d_theta,Ts(i),110/1000);
             z{i}=[theta_hist{i}(end);  opt_vel_1; opt_vel_2; opt_vel_1; opt_vel_2];
%             z{i}=[theta_hist{i}(end);  enc_vel_R(i); enc_vel_L(i); enc_vel_R(i); enc_vel_L(i)];
             if ekf_count(i)==1
                 state_x{i}(1)=pos{i}(1);
                 state_x{i}(2)=pos{i}(2);
                 state_x{i}(3)=theta_hist{i}(end);
                 state_x{i}(4)=opt_vel_1;
                 state_x{i}(5)=opt_vel_2;
             end
             
            [state_x{i},P{i}] = EKF_Update(state_x{i},P{i},z{i},Ts(i));
            state_hist{ekf_count(i),i}=state_x{i};
            raw_dat{ekf_count(i),i}=theta_hist{i}(end);
            
%         end
%     end
%     
    
    totalangle=sum(prev);%sum up all the heading angles of the robots
    mean_angle=totalangle/robot_num;%Take mean of the heading angles to use this as a control input in the theta consensus mode.


%     for i = 1:robot_num  %check if robot is stopped. If so, use auto_explore
        if ekf_count(i)==1
            start_time(i)=now;
        end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         if i <= robot_num  %only run if i<= number of robots
            if x(i).stop_flag(1) == 1
                if now<t_end 
                    if traj_cont==1
                        %%%%%Run in trajectory controller mode%%%%%%
                    [v1,v2,error_x,error_y,ref_traj]=trajectory_controller(state_x{i},start_time(i));
                    traj{ekf_count(i),i}=ref_traj;
                    vel_hist{i}(ekf_count(i),:)=[v1,v2];
                    error_hist{i}(ekf_count(i),:)=[error_x,error_y];
                    cmd=strcat('w',num2str(round(v2)),';',num2str(round(v1)),';',num2str(200),';');
                    x(i).write(1,cmd);

                    elseif thet_con==1
                        %%%%Run in heading consensus mode
                    [mean_angle,obst,c,c_obst]=auto_explore(x(i),1,mean_angle,prev,i,thet_con,c,c_obst);
                    elseif rc==1
                        remote_control(x(i))
                    else
                        %run in default mode: Default mode is
                        default_mode(x(i));
                    %uncomment below to do point to point control
                    %{
                    elseif p2p==1
                        [ref_pts,l]=reference_pts(1);
                        if cnt<=l
                        ref_pts=reference_pts(cnt);
                        ref_pt_x=ref_pts(1);
                        ref_pt_y=ref_pts(2);
                        theta_c=state_x{i}(3);
                        xc=state_x{i}(1);
                        yc=state_x{i}(2);
                        ref_theta=atan2((ref_pt_y-yc),(ref_pt_x-xc));
                        ref_theta=wrapTo2Pi(ref_theta);

                        heading_error=abs(wrapTo2Pi(theta_c)-ref_theta);
                        if  heading_error>0.1

                            v_base=0;
                            kp_th=5;
                            v1=v_base-kp_th*((wrapTo2Pi(theta_c)-ref_theta));
                            v2=v_base+kp_th*((wrapTo2Pi(theta_c)-ref_theta));
                            if v1<50
                                v1=sign(v1)*50;
                            end
                            if v2<50
                                v2=sign(v2)*50;
                            end
                            cmd=strcat('w',num2str(round(v2)),';',num2str(round(v1)),';',num2str(100),';');
                            x(i).write(i,cmd);
                        elseif norm([ref_pt_x,ref_pt_y]-[xc,yc])>0.01

                            kp=100;
                            norm([ref_pt_x,ref_pt_y]-[xc,yc])
                            v=kp*norm([ref_pt_x,ref_pt_y]-[xc,yc]);
                            if v<50
                                v=sign(v)*50;
                            end
                            cmd=strcat('w',num2str(round(v)),';',num2str(round(v)),';',num2str(200),';');
                            x(i).write(i,cmd);
                        else cnt=cnt+1;
                        end
%                         else break
                        end
                    %}
                    end
                   
                end
                x(i).stop_flag(1) = 0;
            end
%         end
        ekf_count(i)=ekf_count(i)+1;
    end
    end
    
    if thet_con==0||thet_con==1
    if count >= 100 ||now>t_end %only update figures every 100 datapoints
        %plot maps (use sfigure instead of figure so it doesn't pop to front)
% % %         for i = 1:robot_num
% % %             %sfigure(m);
% % %             x(i).Update_Map(1);  %IMPLEMENT WITH GUI: call x.Update_Map(robotNumber,map_handle)
% % %             hold on
% % %             pause(0.1)%To give enough time for the map to update
% % %         end
        
        %plot power
        
        l = length(time);  %only plot the last 200 datapoints
        k = 500;
% % %         if l <=k  %if less than 200 datapoints, plot all
% % %             for i = 1:robot_num
% % %                 %sfigure(p);
% % %                 plot(time(i,:),power(i,:));
% % %                 xlabel('x co-ordinates (mm)')
% % %                 ylabel('y co-ordinates (mm)')
% % %                 hold on
% % %             end
% % %         else
% % %             for i = 1:robot_num
% % %                 %sfigure(p);
% % %                 plot(time(i,l-k:l),power(i,l-k:l));
% % %                 xlabel('x co-ordinates (mm)')
% % %                 ylabel('y co-ordinates (mm)')
% % %                 hold on
% % %             end
% % %         end
        %pause(0.3)
        count = 1; %reset counter
    end
    end
    
end
save state_hist state_hist
save raw_dat raw_dat
save error_hist error_hist
save vel_hist vel_hist
% save traj traj
%unhook the bluetooth devices
for i = 1:length(s);
    x(i).unhookBT;
end


fprintf('\nEnded demo\n')

end