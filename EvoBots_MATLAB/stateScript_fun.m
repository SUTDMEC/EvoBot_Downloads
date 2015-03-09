%this script is called from the Taurus_script.m file. It is called for
%post-processing the sensor data and if needed, making sense of the ground truth
%data obtained from the Optitrack prime 41 cameras using the software
%'Motive'-version 1.5.1, 64 bit. 
% The file reads the sensor data from the EvoBots and passes it to the
% function Traj_Est, which performs Kalman filtering on the data to achieve
% a better estimate of the robot's current position/ distance travelled
function [EST,EST_robot_not_obstacle]=stateScript_fun(root_dir,input_dir,inc,uip,bot_data,num_bots,num,txt,raw,thet_con,pos)
try
%% Load all data files, and import files 
h = waitbar(0,'Importing data, please wait...');%launch waitbar
if ~exist('GT_files','var')
    for k=1%not needed
        
        [ nameBot ] = getSubName( strcat(input_dir,'\'));%get names of subdirectories
        
        for m=1:length(nameBot) %get bot names
           filename{k}{m}=strcat(root_dir,'\stateoutput_',inc,'\'); %set filename for stateoutput
           if uip==1%user input flag
           GT_files{k}{m}=dir(strcat(input_dir,'\','\Take*.csv'));% Ground truth pose and trajectory
           GT_name=GT_files{k}{m}.name;%name of the ground truth file
           txt(1:45,:)=[];
           num(1:4,:)=[];
           idx=find(ismember(txt(:,4),strcat('Rigid Body',{' '},inc)));
  
           GTtime{k}{m}=num(idx,2);%time from the ground truth file
           GTx{k}{m}=-num(idx,7);%x positions from ground truth file
           GTz{k}{m}=num(idx,8);%z positions from ground truth file
           GTy{k}{m}=-num(idx,9);%y positions from ground truth file
           GTroll=num(idx,14); %roll angle in degrees-actually the yaw angle
           GTpitch=num(idx,15); %pitch in degrees-not used
           GTyaw=num(idx,16); %yaw in degrees-not used
           GTtheta{k}{m}=GTroll;
           end
           
           Sense_files{k}{m}=dir(strcat(input_dir,'\data',inc,'*.csv'));% Look for Sensor files from the Sensor Data folder
           sense_name=Sense_files{k}{m}.name;%name of sensor file
           raw_sens{k}{m}=importdata(strcat(input_dir,'\',sense_name));%import the sense files
           %assign each column in sense file to a 'data' cell
           data{k}{m}.Time=raw_sens{k}{m}.data(:,1)./1000;% Column 1: Robot Time in ms
           data{k}{m}.Current=raw_sens{k}{m}.data(:,2);% 2: Current in mA
           data{k}{m}.Voltage=raw_sens{k}{m}.data(:,3);	% 3. Battery Voltage 
           data{k}{m}.IR_L=raw_sens{k}{m}.data(:,4);	% 4 L IR sensor readings
           data{k}{m}.IR_C=raw_sens{k}{m}.data(:,5);	% 4 C IR sensor readings
           data{k}{m}.IR_R=raw_sens{k}{m}.data(:,6);	% 4 M IR sensor readings
           data{k}{m}.IMU_X=raw_sens{k}{m}.data(:,7);	% 7. IMU x value after dead-reckoning (NOT Accurate. Probably need some smart way of filtering to make it useful)
           data{k}{m}.IMU_Y=raw_sens{k}{m}.data(:,8);	% 8. IMU y (NOT Accurate. Probably need some smart way of filtering to make it useful)
           data{k}{m}.IMU_YAW=raw_sens{k}{m}.data(:,9);	% 9. IMU yaw in radians- quite accurate
           imu_data=data{k}{m}.IMU_YAW;
           data{k}{m}.OPT_X=raw_sens{k}{m}.data(:,10);% 10. Optical flow x displacement value mm after dead reckoning	
           data{k}{m}.OPT_Y=raw_sens{k}{m}.data(:,11);% 11. Optical flow y displacement value mm after dead reckoning	
           data{k}{m}.OPT_YAW=deg2rad(raw_sens{k}{m}.data(:,12));% 12. Optical flow yaw value after dead reckoning in radians-not very accurate, but can probably be used
           data{k}{m}.L_Encoder=raw_sens{k}{m}.data(:,13).*4.9;  % 13. Left Encoder count (multiply by 4.9 to get distance in mm)-Needs to be calibrated
           data{k}{m}.R_Encoder=raw_sens{k}{m}.data(:,14).*4.9;  % 13. Right Encoder count (multiply by 4.9 to get distance in mm)-Needs to be calibrated
           
           %building the control vector for the data runs after the
           %introduction of control vector feedback
           ct_vec{k}{m}=[raw_sens{k}{m}.data(:,15) raw_sens{k}{m}.data(:,16)];
        end
        waitbar(k/length(nameBot));
    end
end
close(h)


%% Evaluate the data using sensor fusion models

%robot characteristics:

param.mean_current= 72.39; %mA with both motors off and optical flow mouse on
param.mean_voltage= 3.837; %V with both motors off and optical flow mouse on
param.curr_gain=0.6;
param.curr_offset=100;

first_imu_data=imu_data(1);%First IMU data
for i=1:length(imu_data)
    imu_data(i)=imu_data(i)-first_imu_data;%To ensure that the initial heading is taken as 0, and all future headings are measured with respect to the initial heading
end

%%%%%%%%%%%%%%Separate data into IMUData, opticalData, IRData, encoderData
%%%%%%%%%%%%%,powerData and robot time data (senseTime)
for i=1
    for j=1:length(nameBot) %cycle through the robot's test data
        senseTime{i}{j}=data{i}{j}.Time;
        opticalData{i}{j}.d_x=data{i}{j}.OPT_X;
        opticalData{i}{j}.d_y=data{i}{j}.OPT_Y;
        opticalData{i}{j}.theta=imu_data*pi/180;%use gyroscope yaw instead of optical flow yaw
        PowerData{i}{j}.Current=data{i}{j}.Current;
        PowerData{i}{j}.Voltage=data{i}{j}.Voltage;
        IMUData{i}{j}.IMUx=data{i}{j}.IMU_X;
        IMUData{i}{j}.IMUy=data{i}{j}.IMU_Y;
        IMUData{i}{j}.IMUyaw=data{i}{j}.IMU_YAW;
        encoderData{i}{j}.Left=data{i}{j}.L_Encoder;
        encoderData{i}{j}.Right=data{i}{j}.R_Encoder;
        IRData{i}{j}.C=data{k}{m}.IR_C;%center IR data
        IRData{i}{j}.L=data{k}{m}.IR_L;%left IR data
        IRData{i}{j}.R=data{k}{m}.IR_R;%Right IR data
        
        x0=0; %initialize x0
        y0=0; %initialize y0
        theta0=0; %initialize theta0
        
        %%%%%%%%%%%%%%%%%%%%Start state estimation. Call TrajEst%%%%%%%%%%
        disp(strcat('Estimating robot',{' '},inc,{' '},'trajectory...'))
        [ ESTx{i}{j},ESTy{i}{j},ESTtheta{i}{j},ESTthetaP2{i}{j} ] = TrajEst(x0,y0,theta0,senseTime{i}{j},opticalData{i}{j},IMUData{i}{j},PowerData{i}{j},encoderData{i}{j},ct_vec{i}{j},param,'mousemod');%could run this is many other modes apart from 'mousemod'. See TrajEst.m file for details
        ESTtime{i}{j}=senseTime{i}{j}(1:end)-senseTime{i}{j}(1); %Start time from 0
        
        %remove times for which there is clearly an error, and interpolate
        ESTtime_inp{i}{j}=ESTtime{i}{j};
        ESTtime_inp{i}{j}(abs(diff(ESTtime_inp{i}{j}))>3)=nan; %find times with > 3 sec difference (indicative of a data error)
        ESTtime_inp{i}{j}(ESTtime_inp{i}{j}<0)=nan; %find times <0 (indicative of a data error)
        ESTtime_inp{i}{j}=inpaint_nans(ESTtime_inp{i}{j},1);
    end
end


%%Check if the variable GTtime exists. if it does not exist, it means the
%%Ground truth was not requested by the user. So assign the GT variables
%%dummy values, equal to the estimated variables.
if ~exist('GTtime','var')
    GTtime=ESTtime_inp;
    GTx=ESTx;
    GTy=ESTy;
    GTtheta=ESTtheta;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Call the plot function%%%%%%%%%%%%%%%%%%%%
[EST,EST_robot_not_obstacle]=plotStateEst(ESTtime_inp, ESTx,ESTy,ESTtheta,ESTthetaP2,GTtime,GTx,GTy,GTtheta,filename,inc,IRData,bot_data,num_bots,thet_con,pos); %input the interpolated filtered time estimate

catch 
    a=lasterror
    keyboard
end

end