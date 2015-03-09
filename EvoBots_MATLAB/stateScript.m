%%This script is used for testing and evaluating the response of the state estimate function given real operating data
try
    
    
% clear
clc
close all;


root_dir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\Test_Data\Test_Data';

%% Load all data files
% Ground truth pose and trajectory from the Tracking folder
GT_files=getAllFiles(strcat(root_dir,'\Tracking'));
% Sensor files from the Sensor Data folder
Sense_files=getAllFiles(strcat(root_dir,'\Sensor Data'));
% Video files from Videos folder
Vid_files=getAllFiles(strcat(root_dir,'\Videos'));

%% Extract ground truth trajectory for each of the runs
if ~exist('idx','var')
    for i=1:length(GT_files)
        raw=importdata(GT_files{i});
        idx=find(ismember(raw.textdata.Take(:,1),'frame'));

        GTtime{i}=raw.data.Take(idx,2);
        GTx{i}=raw.data.Take(idx,5).*0.5.*1000; %our x converted to mm from m, with a 0.5x factor removed
        GTz{i}=raw.data.Take(idx,6).*0.5.*1000; %our z converted to mm from m, with a 0.5x factor removed
        GTy{i}=raw.data.Take(idx,7).*0.5.*1000; %our y converted to mm from m, with a 0.5x factor removed

        GTroll=raw.data.Take(idx,12); %in degrees
        GTpitch=raw.data.Take(idx,13); %in degrees
        GTyaw=raw.data.Take(idx,14); %in degrees

%         figure
%         plot(GTtime{i},GTroll);
% 
%         figure
%         plot(GTx{i},GTz{i},'*')

        GTtheta{i}=GTroll;
    end
end

%% Extract the sensor data for each of the runs

% 1. Robot time in ms (since the robot started transmitting)
% 2. Current in mA
% 3. Battery Voltage
% 4-6. IR Sensors
% 13 and 14- left and right Encoder counts (multiply this by 4.9 to get distance travelled in mm)
% 
% I am not sure of one of the columns in between 7 and 12. It should be just right optical and left optical flow x and y, and yaw, but there is one extra column which I am not sure of. Mark said he would be coming in sometime today, so I will ask him.



for j=1:length(Sense_files)
   raw_sens{j}=importdata(Sense_files{j});
   data{j}.Time=cellfun(@(x)datenum(x,'HH:MM:SS:FFF'), raw_sens{j}.textdata);
   data{j}.Current=raw_sens{j}.data(:,1);
   data{j}.Voltage=raw_sens{j}.data(:,2);	
   data{j}.IR_L=raw_sens{j}.data(:,3);	
   data{j}.IR_C=raw_sens{j}.data(:,4);	
   data{j}.IR_R=raw_sens{j}.data(:,5);	
   data{j}.IMU_X=raw_sens{j}.data(:,6);	
   data{j}.IMU_Y=raw_sens{j}.data(:,7);	
   data{j}.IMU_YAW=raw_sens{j}.data(:,8);	
   data{j}.L_OPT_X=raw_sens{j}.data(:,9);	
   data{j}.L_OPT_Y=raw_sens{j}.data(:,10);	
   data{j}.R_OPT_X=raw_sens{j}.data(:,11);	
   data{j}.R_OPT_Y=raw_sens{j}.data(:,12);  
end

nRuns=3; %nRuns is the number of runs captured by the motion capture system
sense_per_run=length(raw_sens)/nRuns;

%robot characteristics:
% mean_current= 58.98; %mA with both motors off and optical flow mouse off
% mean_voltage= 3.94; %V with both motors off and optical flow mouse off

param.mean_current= 72.39; %mA with both motors off and optical flow mouse on
param.mean_voltage= 3.837; %V with both motors off and optical flow mouse on
param.curr_gain=0.6;
param.curr_offset=100;

for k=1:nRuns %cycle through each motion capture run
    senseTime{k}=[];
    opticalData{k}.L_x=[];
    opticalData{k}.L_y=[];
    opticalData{k}.R_x=[];
    opticalData{k}.R_y=[];
    PowerData{k}.Current=[];
    PowerData{k}.Voltage=[];
    IMUData{k}.IMUx=[];
    IMUData{k}.IMUy=[];
    IMUData{k}.IMUyaw=[];
    
    %integrate all input data into sensor fusion data structures
    for s=0 %0:sense_per_run-1 %comment this to just do the second sense
        senseTime{k}=[senseTime{k};data{sense_per_run*k-1*s}.Time];
        opticalData{k}.L_x=[opticalData{k}.L_x;data{sense_per_run*k-1*s}.L_OPT_X];
        opticalData{k}.L_y=[opticalData{k}.L_y;data{sense_per_run*k-1*s}.L_OPT_Y];
        opticalData{k}.R_x=[opticalData{k}.R_x;data{sense_per_run*k-1*s}.R_OPT_X];
        opticalData{k}.R_y=[opticalData{k}.R_y;data{sense_per_run*k-1*s}.R_OPT_Y];
        PowerData{k}.Current=[PowerData{k}.Current;data{sense_per_run*k-1*s}.Current];
        PowerData{k}.Voltage=[PowerData{k}.Voltage;data{sense_per_run*k-1*s}.Voltage];
        IMUData{k}.IMUx=[IMUData{k}.IMUx;data{sense_per_run*k-1*s}.IMU_X];
        IMUData{k}.IMUy=[IMUData{k}.IMUy;data{sense_per_run*k-1*s}.IMU_Y];
        IMUData{k}.IMUyaw=[IMUData{k}.IMUyaw;data{sense_per_run*k-1*s}.IMU_YAW];
    end
    
    
    %set the robot starting position according to the ground truth
    %coordinates. Assumes all motion since start of motion capture is
    %captured in the sensor streams
    
    x0=GTx{k}(1);
    y0=GTy{k}(1);
    theta0=deg2rad(GTtheta{k}(1)); %convert motion capture to degrees
    
    %available fusion modes:
    %all = use all measurements
    %mouse= only use optical flow
    %mousemod= use optical flow and model
    %IMU=only use IMU
    %IMUmod=use IMU and model
    %model=only use model
    %Future: Encode, Encodemod
    
    %reset sense-time back 1/100 second to reflect the fact that the sensors start from first motion 0
    senseTime{k}=[senseTime{k}(1)-0.01/3600/24;senseTime{k}];
    
    [ ESTx{k},ESTy{k},ESTtheta{k} ] = TrajEst(x0,y0,theta0,senseTime{k},opticalData{k},IMUData{k},PowerData{k},param,'mouse');
    
    %time is synchronized in the plotStateEst function which compares
    %estimates to ground truth
    ESTtime{k}=senseTime{k};
    
end

plotStateEst(ESTtime, ESTx,ESTy,ESTtheta,GTtime,GTx,GTy,GTtheta);

catch 
    a=lasterror
    keyboard
end