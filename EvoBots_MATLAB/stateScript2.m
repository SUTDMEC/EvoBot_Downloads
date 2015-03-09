%%This script is used for testing and evaluating the response of the state estimate function given real operating data
try

%This version of the script is used to process text-style input files
    
% 
% To Do: 5 Aug 14 EW
% 
% -wrap model to PI to match measurements
% - wrap output to PI/2
% - Tune EKF parameters
% - parse in real control inputs
% - tune parameters of splicing script

% clear
clc
close all;


root_dir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\11_July_Tests\11_July_Tests'; %july 11th tests (manual control vector)
% root_dir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\5_Aug_Tests\5_Aug_Tests'; %Aug 5th tests - continuous control vec

[ nameTests ] = getSubName( root_dir );

%% Load all data files, and import files 
h = waitbar(0,'Importing data, please wait...');
if ~exist('GT_files','var')
    for k=1:length(nameTests) %get all tests
        [ nameRun ] = getSubName( strcat(root_dir,'\',nameTests{k}) );
        for m=1:length(nameRun) %get all run names for each test
           filename{k}{m}=strcat(root_dir,'\',nameTests{k},'\',nameRun{m});
           GT_files{k}{m}=dir(strcat(root_dir,'\',nameTests{k},'\',nameRun{m},'\*.csv'));% Ground truth pose and trajectory from the Tracking folder 
           Sense_files{k}{m}=dir(strcat(root_dir,'\',nameTests{k},'\',nameRun{m},'\*.txt'));% Sensor files from the Sensor Data folder
           %import Ground Truth data
           raw=importdata(strcat(root_dir,'\',nameTests{k},'\',nameRun{m},'\',GT_files{k}{m}.name),',',47);
           [num,txt,raw] = xlsread(strcat(root_dir,'\',nameTests{k},'\',nameRun{m},'\',GT_files{k}{m}.name));
           txt(1:45,:)=[];
           num(1:4,:)=[];
           idx=find(ismember(txt(:,1),'frame'));
           
           GTtime{k}{m}=num(idx,2);
           GTx{k}{m}=-num(idx,5).*2; %our x converted to mm from m, with a 0.5x factor removed (new calibration) (NEG axis)
           GTz{k}{m}=num(idx,6).*2; %our z converted to mm from m, with a 0.5x factor removed (new calibration)
           GTy{k}{m}=num(idx,7).*2; %our y converted to mm from m, with a 0.5x factor removed (new calibration)
           GTroll=num(idx,12); %in degrees
           GTpitch=num(idx,13); %in degrees
           GTyaw=num(idx,14); %in degrees
           GTtheta{k}{m}=GTroll;

           %import sensor data

           raw_sens{k}{m}=importdata(strcat(root_dir,'\',nameTests{k},'\',nameRun{m},'\',Sense_files{k}{m}.name));
               
           data{k}{m}.Time=raw_sens{k}{m}.data(:,1)./1000;% Column 1: Robot Time in ms
           data{k}{m}.Current=raw_sens{k}{m}.data(:,2);% 2: Current in mA
           data{k}{m}.Voltage=raw_sens{k}{m}.data(:,3);	% 3. Battery Voltage 
           data{k}{m}.IR_L=raw_sens{k}{m}.data(:,4);	% 4 L IR sensor readings
           data{k}{m}.IR_C=raw_sens{k}{m}.data(:,5);	% 4 C IR sensor readings
           data{k}{m}.IR_R=raw_sens{k}{m}.data(:,6);	% 4 M IR sensor readings
           data{k}{m}.IMU_X=raw_sens{k}{m}.data(:,7);	% 7. NOT IMU x value after dead-reckoning (NOT WORKING)
           data{k}{m}.IMU_Y=raw_sens{k}{m}.data(:,8);	% 8. NOT IMU y value after dead-reckoning (IMU displacement in  forward robot direction mm multiply by COS/SIN(YAW) to get it in global coordinates
           data{k}{m}.IMU_YAW=raw_sens{k}{m}.data(:,9);	% 9. IMU yaw in radians
           data{k}{m}.OPT_X=raw_sens{k}{m}.data(:,10);% 10. Optical flow x displacement value mm after dead reckoning	
           data{k}{m}.OPT_Y=raw_sens{k}{m}.data(:,11);% 11. Optical flow y displacement value mm after dead reckoning	
           data{k}{m}.OPT_YAW=deg2rad(raw_sens{k}{m}.data(:,12));% 12. Optical flow yaw value after dead reckoning in radians
           data{k}{m}.L_Encoder=raw_sens{k}{m}.data(:,13).*4.9;  % 13. Left Encoder count (multiply by 4.9 to get distance in mm)
           data{k}{m}.R_Encoder=raw_sens{k}{m}.data(:,14).*4.9;  % 13. Right Encoder count (multiply by 4.9 to get distance in mm)
           
           %building the control vector for the data runs after the
           %introduction of control vector feedback
%            ct_vec{k}{m}=[raw_sens{k}{m}.data(:,15) raw_sens{k}{m}.data(:,16)];
        end
        waitbar(k/length(nameTests));
    end
end
close(h)

%% Build control input vector for each test

%NOTE: THIS SECTION SHOUDL BE AUTOMATED IN THE FUTURE BASED ON COMMANDS
%PARSED FROM THE SENSOR DATA FILE. For the time being, the commands in the
%sensor data file were partially removed

% NOTE: THIS SECTION OF CODE ONLY VALID FOR THE 11th of JULY TESTS
if ~exist('ctr','var')
    control=importdata(strcat(root_dir,'\TestPowerToControlMapping.xlsx'));
    ctr=struct2cell(control.data);

    field_ind=1;

    for i=1:k
        for j=1:m
            ct_vec{i}{j}=zeros(length(data{i}{j}.Time),2); %initialize the control vector
            [sdr ~]=size(ctr{field_ind});
            v_ind=2;
            for s=1:length(data{i}{j}.Time) %cycle through process the data into a control vector to the length of the data file
                if v_ind<=sdr %allows to run out the last value
                    if s>ctr{field_ind}(v_ind,1) %cycle the indicies
                        v_ind=v_ind+1;
                    end
                end
                ct_vec{i}{j}(s,1)=ctr{field_ind}(v_ind-1,2); %left motor control
                ct_vec{i}{j}(s,2)=ctr{field_ind}(v_ind-1,3); %right motor control
            end
    %         keyboard
           field_ind=field_ind+1;
        end
    end

end



%% Evaluate the data using sensor fusion models

%robot characteristics:
% mean_current= 58.98; %mA with both motors off and optical flow mouse off
% mean_voltage= 3.94; %V with both motors off and optical flow mouse off

param.mean_current= 72.39; %mA with both motors off and optical flow mouse on
param.mean_voltage= 3.837; %V with both motors off and optical flow mouse on
param.curr_gain=0.6;
param.curr_offset=100;



for i=1%:length(nameTests) %cycle through each robot's pattern test
    
    for j=1:length(nameRun) %cycle through the repetition of that robot's test
        senseTime{i}{j}=data{i}{j}.Time;
        opticalData{i}{j}.d_x=data{i}{j}.OPT_X;
        opticalData{i}{j}.d_y=data{i}{j}.OPT_Y;
        opticalData{i}{j}.theta=data{i}{j}.OPT_YAW;
        PowerData{i}{j}.Current=data{i}{j}.Current;
        PowerData{i}{j}.Voltage=data{i}{j}.Voltage;
        IMUData{i}{j}.IMUx=data{i}{j}.IMU_X;
        IMUData{i}{j}.IMUy=data{i}{j}.IMU_Y;
        IMUData{i}{j}.IMUyaw=data{i}{j}.IMU_YAW;
        encoderData{i}{j}.Left=data{i}{j}.L_Encoder;
        encoderData{i}{j}.Right=data{i}{j}.R_Encoder;
        
        %plot current to identify control vector
%         figure
%         plot(PowerData{i}{j}.Current)
%         title(num2str(i*j))
        %set the robot starting position according to the ground truth
        %coordinates. Assumes all motion since start of motion capture is
        %captured in the sensor streams

        x0=GTx{i}{j}(1);
        y0=GTy{i}{j}(1);
        theta0=deg2rad(GTtheta{i}{j}(1)); %convert motion capture to radians
        
%         keyboard
        %available fusion modes:
        %all = use all measurements
        %mouse= only use optical flow
        %mousemod= use optical flow and model
        %IMU=only use IMU
        %IMUmod=use IMU and model
        %model=only use model
        %encoder = encoder data
        %encodermod = encoder and model
 
        [ ESTx{i}{j},ESTy{i}{j},ESTtheta{i}{j},ESTthetaP2{i}{j} ] = TrajEst(x0,y0,theta0,senseTime{i}{j},opticalData{i}{j},IMUData{i}{j},PowerData{i}{j},encoderData{i}{j},ct_vec{i}{j},param,'mousemod');

        %time is synchronized in the plotStateEst function which compares estimates to ground truth
        %note - last point measured is always dropped in post-processing
        %for integration reasons
        ESTtime{i}{j}=senseTime{i}{j}(1:end)-senseTime{i}{j}(1); %reset the time for the est time back to 0, and add an extra value for the starting position
%         ESTtime{i}{j}=[0; ESTtime{i}{j}]; %add extra 0
        
        %remove times for which there is clearly an error, and interpolate
        ESTtime_inp{i}{j}=ESTtime{i}{j};
        ESTtime_inp{i}{j}(abs(diff(ESTtime_inp{i}{j}))>3)=nan; %find times with > 3 sec difference (indicative of a data error)
        ESTtime_inp{i}{j}(ESTtime_inp{i}{j}<0)=nan; %find times <0 (indicative of a data error)
        ESTtime_inp{i}{j}=inpaint_nans(ESTtime_inp{i}{j},1);
%         keyboard
    end
    
    

    
end


%plot results
plotStateEst(ESTtime_inp, ESTx,ESTy,ESTtheta,ESTthetaP2,GTtime,GTx,GTy,GTtheta,filename); %input the interpolated filtered time estimate

catch 
    a=lasterror
    keyboard
end