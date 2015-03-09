%% This object handles the communication with the robots




%% This script should form the back-bone of the  EvoBot SLAM code
% it is being written for later integration with the GUI
try
    %%Synch PC timestamps
    %% Add directories to search
    addpath('C:\Users\SUTD\Documents\MATLAB\robot-9.8');
     dir='Z:\Temasek Laboratories\STARS\sensorData\';
%    dir= 'C:\Users\Abhishek\Documents\sensor values\';
    %% Initialize all connections
    % make sure the Bluetooth_initialization is edited (depending on the
    % robots you want to connect)and it did run before changing the
    % number of robot 
    in.robot_num=1; % number of robots connected
    in.s=s;
  
    for i=1:in.robot_num %running the loop for each robot
        fopen(in.s(i));     % opening the bluetooth port
        % Opening the file to save all the data
        print= i
        in.fileID(i) = fopen(strcat(dir,num2str(i),'_sensor_data',datestr(now,'yy_mm_dd_HH_MM'),'.csv'),'wt');
        fprintf(in.fileID(i),'Evobot Gen01 - Sensor Stream, Time Commenced:');
        fprintf(in.fileID(i),datestr(clock));
        fprintf(in.fileID(i),'\n\r\n\rTime,Current,Voltage,IR_L,IR_C,IR_R,REAR R,REAR L,YAW,L_OPT_X,L_OPT_Y,R_OPT_X,R_OPT_Y\n\r');
        %sending '&' to the robot for initializin
        fprintf(in.s(i), '%c', '&');
        pause(0.05);
        str=fscanf(in.s(i));
        pause(0.05)
        %getting the initial orientation by getting the Yaw values for 5
        %times and taking the mode
        for j=1:5           
            fprintf(in.s(i), '%c', 'Y');
            pause(0.05);
            str=fscanf(in.s(i));
            temp = strsplit(str,';');
            Yaw(j)=str2double(temp{2});
            pause(0.05)
        end
        in.My_Yaw(i)= mode(Yaw);
        in.yaw_offset(i)=90-in.My_Yaw(i);   % getting the offset as each robot is assumed to take 90 deg
        %the speed of the robot first three character for the left motor,
        %nrxt three for the right, then next four the duration, the speed
        %varies from 0 to 200 with 0 is 100% in backward direction and 200
        %is 100% in forward direction, so 0-200 means -100% to 100%
        in.R_speed{i}='w200;200;2000;';        
        in.prev_left_optical{i}=[-1.5+800*(i-1),0]; %-1.5 is the distance between the center and the optical sensor location
        in.prev_right_optical{i}=[1.5+800*(i-1),0]; %1.5 is the distance between the center and the optical sensor location
        %update current position
        in.x{i}=0+800*(i-1);
        in.y{i}=0;
        in.theta{i}=90;
    end
    %% Run the SLAM iteratively
    % note - SLAM occurs after 'movement windows' which were planned in the
    % preceding SLAM step
    while(1) 
        i = 1 ;%loop counter
        in.i=i;
        in.k=1; %landmark location index
        in.run_start=now; % TIME FOR VIDEO SEGMENT!! - may want to store these as cell arrays so in{i} is recorded...need to change this in a few places
        %in.plan = instruction for the current step
        %start timer object
        % Synch with robot
        moveEvoBot (in);
        in.time_start = now;%time when the motor command was started
        %run movement step
        for n=1:in.robot_num
            in.n=n;
            j=1;
            in.j=j;
            command_running = 1;
            while (command_running==1) %sensor data loop - Robot is moving
                %read sensor data
                %in: in.fileID = name of data file
                %in.s = bluetooth serial object
                %in.R_speed = robot speed
                sens_out{in.n,j} = readSensors(in);
                interrupt = sens_out{in.n,j}.interrupt;
                command_running = sens_out{in.n,j}.command_running;
                %out: sense_out.data=cell array of sensor data from robot
                if (interrupt==1)
                    disp('Flag On: Obstacle Detected!');
                    break;
                end
                j=j+1;
            end
            in.run_stop=now;
            in.data = sens_out;
            sense_data{i}=sens_out; %persist the data for debugging
            in.sense_data=sense_data;
            in.sense_save{i}=sense_data{i};
            clear sens_out;
            %read camera data for movement periodvideo segmen
            %takes in.run_start and in.run_stop and cuts thet for
            %that time
            % cam_out{i} = readCam ( in );
            %in data is previously defined
            % [vids{i}, vid_timestamps{i}, folder_temp{i}, start_name, end_name]=readCam(in.run_start,in.run_stop,ii,t1);
            %      [vids{i}, vid_timestamps{i}, folder_temp{i}]=readCam(in.run_start,in.run_stop,ii,t1);
            %      in.picture = vid_timestamps{i};
            %      in.image_dir=folder_temp{i}; % folder name (new each run) where the run's images are stored
            %  %     in.vids=vids;     %comented this out as of the in file size
            %      in.pic_save{i}=vid_timestamps{i};
            %     in.vid_save{i}=vids;  %comented this out as of the in file size
            %perform state estimates
            %         in.passthrough=1; %signals to not perform synchronization of data
            %         synch_data{i}= synchEvo (in);
            %         in.synch_data_save{i}=synch_data{i}; %redundant data saving structure
            %         %     keyboard
            %         if ~synch_data{i}.empty.flag %if there are all valid timeseries, run analysis
            %
            %             in.synch_data=synch_data{i};
            %             in.optical_flow=0; %flag to decide if optical flow should be run
            %         in.pic_sync=synch_data{i}.pic_sync;
            state_out{i} = stateEstimate ( in );
            in.l_optical_movement=state_out{i}.l_optical_movement;
            in.r_optical_movement=state_out{i}.r_optical_movement;
            %_______________________
            in.state{i}=state_out{i};
            in.prev_left_optical{in.n}=state_out{i}.mice_state.previous_left{in.n};
            in.prev_right_optical{in.n}=state_out{i}.mice_state.previous_right{in.n};
            %search for features
            in.x{in.n}= state_out{i}.x;
            in.y{in.n}=  state_out{i}.y;
            in.theta{in.n}= state_out{i}.theta;
            in.map_out{i} = slam_map(in);
            %_______________________
            %to be removed later only for debugging
            % gives out an array of cordinates of landmark locations
            % THOMMEN
            %         delta=in.x(end)-in.x(1);
            %         dist=get_dist(in.image_dir, start_name, end_name,delta)
            %         else %synch returned a 'no data' flag
            %             disp('Synch failed');
            %             %         disp(synch_data{i}.empty.ts);
            %             if isfield(synch_data{i}.empty,'intime')
            %                 disp(synch_data{i}.empty.intime);
            %                 disp(synch_data{i}.empty.indata);
            %             elseif isfield(synch_data{i}.empty,'intime')
            %                 disp(synch_data{i}.empty.ts1);
            %                 disp(synch_data{i}.empty.ts1);
            %             end
            %
            %         end
            %plot current run data
            plotRun(in);
            %plan next movement
            i = i + 1;
            in.i=i;
            plan_out{i} = planner (in);
            in.R_speed{in.n}=plan_out{i}.R_speed{in.n};
            %keyboard
        end
    end
    
    %save aggregated data to a .mat file if run is successful
    fileout = saveData (in);
    if (fileout.success)
        disp('Saved successful Run with name:')
        disp(fileout.filename)
    end
    
    %% Close all connections
    
    %close serial port connection
    fclose(in.s);
    
    %close video stream connection
    
    %return optical control
    stop(timerObj);
    
    %close data log file
    fclose(in.fileID);
    
catch
    a=lasterror
    keyboard
end
%% TODO

%- work out while loop timing - figure out all function timing
% - Add logging for all sensor streams
% PAUSE IN moveEvoBot