%% This is the main script of the CoSLAM package. It asks for user inputs, 
%calls the state estimation files, plots the data, generates the recording 
%files and ssh's into the remote linux machine, and executes the recording
%command. It also generates the input.txt files for running CoSLAM and runs
%it on the remote linux machine through ssh
clear all
clc
% Current EvoBot fleet of 7 bots, have the following names and camera IP
% addresses
% Evobot_03     192.168.28.118
% Evobot_30     192.168.28.115
% Evobot_08     192.168.28.113
% Evobot_11     192.168.28.117
% Evobot_01     192.168.28.110
% Evobot_21/211 192.168.28.114 (on some PC's 21, most on 211)
% Evobot_10     192.168.28.116
thet_con=0;
traj_cont=0;
rc=0;
try

main_dir=pwd;%main directory of this package
test_config=input('Enter 1 to run test using same configurations as previous run.\nTo setup a fresh configuration, enter 0:\n');
if test_config==1
    load prev_run.mat %if 1 was pressed, use the previously recorded bluetooth settings and linux directories
end
ld=exist('linux_dir');
if ld>0
    disp(strcat('Using the directory:',{' '},linux_dir))
else
    linux_dir=input('Enter the path of your linux directory.\nExample:''/home/user/CoSLAM/run''\n');%ask for user input for linux paths 
    linux_IP=input('Enter the IP address of the Linux workstation. Example, ''192.168.48.127''\n');%Ask for IP address
end

root_dir=strcat(main_dir,'\Sensor_logs');%Path to Sensor log folder
%%%%%%%%%%%%%%%%%%%%%Bluetooth Configuration%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(main_dir)
ex=exist('bt');%If the user chose the same configuration as previous run
if ex>0
    num_bots=length(bt);
else
    blu=input('Enter number of robots to be configured '); 
    i=1;
    while i<=blu
        bt_name=input('Enter name of the bluetooth device.\nExample: ''Evobot_01''\n');
        disp('Configuring robot. Please wait...')
        bt(i)=Bluetooth(bt_name,1);
        disp(strcat('Robot',{' '},num2str(i),{': '},bt_name,' configured'));
        cam_ip{i}=input('Enter the Camera IP address of this robot.Example: ''192.168.28.111''\n');
        pos{i}=input('Enter the initial x,y positions and heading of this robot. Example: [0.5,1.5,pi]\n');
        i=i+1;
    end
      num_bots=length(bt);
end
disp('All robots successfully configured.')
save prev_run.mat linux_dir bt cam_ip linux_IP pos%Save linux directory and bluetooth variables
copyfile('prev_run.mat', strcat(main_dir,'\Throwbot_GUI\Robot_Class\Libraries'));%Copy the prev_run mat file to the Libraries folder so that it can be read from there
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create test folders%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(strcat(main_dir,'\Sensor_logs'))
con=dir;
count=0;
if length(con)>2
    %Find how many folder start with 's'
    for j=3:length(con)
        if strcmp(con(j).name(1),'s')
            count=count+1;
        end
    end
    l=length(con)-count;
%find the largest folder number and increment it by 1. Make directory 'data' inside this newly created folder     
for i=3:l
    folders(i-2)=str2num(con(i).name);
end
mkdir(num2str(max(folders)+1));
test_folder=num2str(max(folders)+1);
cd(test_folder)
mkdir('data')
else
mkdir('1');
test_folder='1';
cd(test_folder)
mkdir('data')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Ask user for recording of video%%%%%%%%%%%%%%%%%%%%%%
record_vid=input('Would you like to record video?\n1-yes/0-no \n');

%%%%%%%%%%%%%%%%%%%%%%Ask user for duration of test run%%%%%%%%%%%%%%%%%%%%
delta_t=input('How many seconds would you like to run the test for?\n');
t_st=now;%record the current time
if record_vid
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create record.sh file%%%%%%%%%%%%%%%%%%%%%%%
    cd(strcat(main_dir,'\ssh2_v2_m1_r6'))
    disp('Generating record script...')
    comm=strcat('printf',{' '},'"','#!/bin/bash','\n','"',{' '},'>',{' '},'record.sh');
    command_output = ssh2(linux_IP,'robot','robot',char(comm));%ssh into linux PC and create record.sh
    for k=1:num_bots
        comm=strcat('printf',{' '},'"','env DISPLAY=:0 cvlc http://',cam_ip{k},'/?action=stream --sout',{' '},strcat('file/avi:',linux_dir,'/vid/vid',num2str(k),'.avi'),{' '},strcat('--sout-display --run-time=',num2str(delta_t),{' '},'vlc://quit &\n'),'"',{' '},'>>',{' '},'record.sh');
        command_output = ssh2(linux_IP,'robot','robot',char(comm));%ssh and write into record.sh
    end
    comm=strcat('chmod u+x record.sh');%make the record script executable
    command_output = ssh2(linux_IP,'robot','robot',char(comm));
    disp('Successfully created record.sh file')
    %%%%%%%%%%%Execute ssh command to start video recording%%%%%%%%%%%%%%%%%%%%
    %Begin Recording
    command_output = ssh2(linux_IP,'robot','robot','./record.sh'); %run the record.sh script
    disp('Video recording started...')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% t_en=now;%record the current time
% t_reco=24*3600*(t_en-t_st);%check how much time passed
% t_left=delta_t-t_reco;%Check time left


%%%%%%%%%%%%%%%%%%%%%%%%%%%Run Robot_Script to run the robots%%%%%%%%%%%%%%
cd(strcat(main_dir,'\Throwbot_GUI\Robot_Class'))
thet_con=input('Do you want to run in theta consensus mode? 0-no/1-yes');
if thet_con==0
traj_cont=input('Do you want to run in trajectory controller mode? 0-no/1-yes');
if traj_cont==0
    rc=input('Do you want to run in remote control mode? 0-no/1-yes');
end
end
if thet_con==1
    mode='Heading Consensus Mode';
elseif traj_cont==1
    mode='Trajectory Controller Mode';
elseif rc==1
    mode='Remote Control Mode';
else mode='Default Mode';
end
disp('Beginning Run...');
disp(mode);
t_start=now;%record current time
t_end=t_start+(delta_t/60/60/24);%set ending time as current time plus delta_t, converted to a fraction of a day
Robot_Script(strcat(main_dir,'\Sensor_logs\',test_folder,'\data'), bt, t_end,thet_con,traj_cont,rc,pos);%call Robot_Script
disp('Run complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%Post-process robot run using statescript%%%%%%%%%%%%%%
post_process=input('Do you want to run post-processing? 0-no/1-yes');
if post_process==1

    disp('Post-processing sensor data...')
    cd(main_dir) 
    uip=0;%user input flag: 0 if user chose not to compare with ground truth and 1 otherwise
    bot_data={};%initialize bot_data
    for k=1:num_bots
        if k==1
            y=1;%yes 
            n=0;%no
            uip=input('Do you want to compare with Ground Truth? y/n ');%Get user input y/n
            if uip==1
                disp(strcat('Please place Ground truth file in',{' '},strcat(main_dir,'\Sensor_logs\',test_folder), {' '},'and press enter' ))
                pause
                disp('Importing ground truth data...')
               GT_files=dir(strcat(main_dir,'\Sensor_logs\',test_folder,'\Take*.csv'));% find the Ground truth file
               GT_name=GT_files.name;%get the name of the ground truth file
               raw=importdata(strcat(main_dir,'\Sensor_logs\',test_folder,'\',GT_name));%import ground truth
               [num,txt,raw] = xlsread(strcat(main_dir,'\Sensor_logs\',test_folder,'\',GT_name));%read file
            else num=[];%if user does not want ground truth comparison, set num, txt and raw to []
                txt=[];
                raw=[];
            end
        end
        [EST,EST_robot_not_obstacle]=stateScript_fun(strcat(main_dir,'\Sensor_logs\'),strcat(main_dir,'\Sensor_logs\',test_folder),num2str(k),uip,bot_data,num_bots,num,txt,raw,thet_con,pos);%call stateScript_fun
        bot_data{k}=EST;
    end

    if record_vid%if video recording was made, do CoSLAM
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%Retrieve video files%%%%%%%%%%%%%%%%%%%%%%%%
        cd(strcat(main_dir,'\ssh2_v2_m1_r6'));
        disp('Retrieving Video Data...')
        for k=1:num_bots
            ssh2_conn = scp_simple_get(linux_IP,'robot','robot',strcat(linux_dir,'/vid/','vid',num2str(k),'.avi'),main_dir);%get video files into the main directory
        end
        disp('Done!')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%Process video files to get first movement%%%%%%%%%%%%%%%
        disp('Processing video files...')
        cd(main_dir)
        for k=1:num_bots
        [ mean_framerate, vid_length, frameTimes,startFrame ] = Parse_vid2( main_dir,strcat('vid',num2str(k),'.avi') );%Call the parse_vid function
        end
        disp('Finished parsing videos')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Generate input.txt file%%%%%%%%%%%%%%%%%%%%%%%
        %input file is written directly into the linux_dir folder in the linux machine via ssh
        cd(strcat(main_dir,'\ssh2_v2_m1_r6'))
        disp('Generating input file for CoSLAM...')
        comm=strcat('cd',{' '},linux_dir,{' '},'&&',{' '}, 'printf',{' '},'"',num2str(num_bots),'\n','"',{' '},'>',{' '},'input.txt');
        command_output = ssh2(linux_IP,'robot','robot',char(comm));
        for k=1:num_bots
            comm=strcat('cd',{' '},linux_dir,{' '},'&&',{' '}, 'printf',{' '},'"','0 0\n','"',{' '},'>>',{' '},'input.txt');
            command_output = ssh2(linux_IP,'robot','robot',char(comm));
        end
        for k=1:num_bots
            comm=strcat('cd',{' '},linux_dir,{' '},'&&',{' '}, 'printf',{' '},'"','vid/vid',num2str(k),'.avi\n','"',{' '},'>>',{' '},'input.txt');
            command_output = ssh2(linux_IP,'robot','robot',char(comm));
        end
        for k=1:num_bots
            comm=strcat('cd',{' '},linux_dir,{' '},'&&',{' '}, 'printf',{' '},'"','cal/cal1_vga.txt\n','"',{' '},'>>',{' '},'input.txt');
            command_output = ssh2(linux_IP,'robot','robot',char(comm));
        end
        for k=1:num_bots
            comm=strcat('cd',{' '},linux_dir,{' '},'&&',{' '}, 'printf',{' '},'"','odo/odo',num2str(k),'.csv\n','"',{' '},'>>',{' '},'input.txt');
            command_output = ssh2(linux_IP,'robot','robot',char(comm));
        end
        disp('Successfully created input file')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%Send coslaminputs.csv to linux machine%%%%%%%%%%%%%%%%%%
        disp('Transferring coslaminputs to linux machine...')
        for k=1:num_bots
            cd(strcat(main_dir,'\Sensor_logs\stateoutput_',num2str(k)));%cd to the correct folder
            movefile('coslaminput.csv',strcat('coslaminput_',num2str(k),'.csv'));%Rename the coslaminput.csv files with coslaminput_ID.csv
            copyfile(strcat(main_dir,'\Sensor_logs','\stateoutput_',num2str(k),'\coslaminput_',num2str(k),'.csv'),strcat(main_dir,'\for_sending_ssh2_v2_m1_r6'));%copy this file into the correct directory before sending it
            cd(strcat(main_dir,'\for_sending_ssh2_v2_m1_r6'));
            ssh2_conn = scp_simple_put(linux_IP,'robot','robot',char(strcat('coslaminput_',num2str(k),'.csv')));%paste this coslaminput file to the linux machine via ssh
        end
        cd(strcat(main_dir,'\ssh2_v2_m1_r6'));
        %write these files into the CoSLAM directory
        for k=1:num_bots
            comm=char(strcat('cp',{' '},strcat('coslaminput_',num2str(k),'.csv'),{' '},linux_dir));%copy the coslaminput files to the linux directory
            command_output = ssh2(linux_IP,'robot','robot',comm);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%invoke CoSLAM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Keep giving user the option of running CoSLAM again till he presses 0.
        %Useful if CoSLAM fails the first time or if we CoSLAM needs to be run
        %again
        cnt=0;%count
        while cnt>-1
        disp('Starting CoSLAM...')
        comm=char(strcat('cd',{' '},linux_dir,{' '}, '&&',{' '}, 'env DISPLAY=:0 CoSLAM input.txt'));
        command_output = ssh2(linux_IP,'robot','robot',comm);%run CoSLAM
        cnt=cnt+1;
        if cnt>0
            y=1;
            n=2;
            userip=input('Run CoSLAM again? y/n');
            if userip==y
                cnt=cnt+1;
            elseif userip==n
                cnt=-1;
            end
        end
        end

    end 
end

catch err
    a=err.message
    b=err.stack
    keyboard
end
cd(main_dir)%to get ready for the next run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%~Fin~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%