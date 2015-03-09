classdef RobotData < handle
    properties
        n = 16;     %n is the expected number of data inputs. This must be 
                    %changed if you want to add extra data to the end. 
        ID = -1;    %robot ID of this data object
        column=zeros(1,16);      %data from robot 
        calib_column=zeros(1,16);%calibration (scaling) values for each column
                    
        time =0;    %Timestamp
        dt=0;          %time since last sample
        time_offset;   %time offset from matlab. Add this to 'time' to get
                        %global time of robot

        titles={'time','current','Voltage','IR_L','IR_C','IR_R',...
            'IMU_disp_X','IMU_disp_Y','Yaw','Opt_flow_X','Opt_flow_Y','Opt_flow_YAW',...
            'Encoder_X','Encoder_Y','Motor_L','Motor_R'}      %names of each column
        power=0; %calculate power used (mW)
        current=0; %current draw (mA)
        voltage=0; %voltage (V)
        power_drain=0; %calculate power drain (mAh)
        imu_state=[0,0,0];      %x,y,theta from IMU
        encoder_state=[0,0,0];  %x,y,theta from encoders
        opt_flow_state=[0,0,0]; %x,y,theta from optical flow
        state_offset=[0,0,0]; %initial state offset (x,y,theta)
        
        misc_state=[0,0,0];  %this state is reserved for user
        misc_state2=[0,0,0];
        
        ir_data = [0,0,0];  %save the current IR data
        
        obstacle_flag = zeros(1,16); %indicates if robot sees obstacle in front of it
%         stop_flag = 0;     %indicates if robot has stopped
        
        map = RobotMap;      %map object for this robot. Contains obstacles
                            %and robot path       
        save_path = ''; %directory in which to save data
        fileID = '';    %file ID where data is saved
        filename = '';  %full file path plus name
       
    end
    
    properties (SetAccess = private, GetAccess = private)
        imu_col = [7,8];    %specify column numbers that contain IMU data (x,y)
        opt_col= [10,11,12];   %specify column numbers that contain optical flow data
        encoder_col=[13,14];%specify column numbers that contain encoder data
        yaw_col = 9;        %specify column numbers that contain YAW
        IR_col = [4,5,6];   %specify column numbers that contain IR data
        
        IR_spacing = 72;    %spacing between IR sensors (degrees)
    end  %/private properties
    methods
        %specify the yaw offset
        function yaw_offset(obj,offset)
            obj.state_offset(3) = obj.column(obj.yaw_col) -90; %subt 90 so the 'zero' is fwd
            if obj.state_offset(3) < -180
                obj.state_offset(3) = obj.state_offset(3) + 360;
            end
        end
        
        %update the states for all methods using ODOMETRY
        function odometry(obj,select)
            %update IMU state estimation 
            obj.imu_state(3) = obj.column(9) - obj.state_offset(3);  %yaw (between -180 and 180 degrees)
            if obj.imu_state(3) > 180  %if yaw is >180, wrap around to -180
                obj.imu_state(3) = obj.imu_state(3) - 360;
            elseif obj.imu_state(3) < -180 %if yaw <-180, wrap to +180
                obj.imu_state(3) = obj.imu_state(3) + 360;
            end
            obj.imu_state(2) = obj.imu_state(2) ...
                + obj.column(obj.imu_col(1))*obj.cos_ ...
                + obj.column(obj.imu_col(2))*obj.sin_ ...
                - obj.state_offset(2);  %Y (global)
            obj.imu_state(1) = obj.imu_state(1) ...
                + obj.column(obj.imu_col(1))*obj.sin_ ...
                + obj.column(obj.imu_col(2))*obj.cos_...
                - obj.state_offset(1);  %X (global)
            
            %update ENCODER state estimation
            obj.encoder_state(3) = obj.imu_state(3);
            obj.encoder_state(2) = obj.encoder_state(2) ...
                + obj.column(obj.encoder_col(1))*obj.cos_ ...
                + obj.column(obj.encoder_col(2))*obj.sin_...
                - obj.state_offset(2); %Y (global)
            obj.encoder_state(1) = obj.encoder_state(1) ...
                + obj.column(obj.encoder_col(1))*obj.sin_ ...
                + obj.column(obj.encoder_col(2))*obj.cos_...
                - obj.state_offset(1);  %X (global)
            
            %update OPTICAL FLOW state estimation
            obj.opt_flow_state(3) = obj.imu_state(3); %Yaw
            obj.opt_flow_state(2) = obj.opt_flow_state(2)...
                + obj.column(obj.opt_col(1))*obj.cos_ ...
                + obj.column(obj.opt_col(2))*obj.sin_...
                - obj.state_offset(2);  %Y (global)
            obj.opt_flow_state(1) = obj.opt_flow_state(1)...
                + obj.column(obj.opt_col(1))*obj.sin_ ....
                + obj.column(obj.opt_col(2))*obj.cos_...
                - obj.state_offset(1);  %X (global)   
            
            %update power draw
            obj.power = obj.column(3)*obj.column(2);
            obj.voltage = obj.column(3);
            obj.current = obj.column(2);
%             obj.time = obj.column(1);
        end       
        
        %calculate position of obstacles, select which odometry method to
        %use
        function position_on_map(obj, select)
            location = [0,0]; %save the calculated obstacle location in this
            obj.ir_data = obj.column(obj.IR_col(1:3)); %save the IR values

            %select which odometry method to use
            switch select
                case 1     %use encoder odometry
                    temp_state = obj.encoder_state;
                case 2     %use optical flow odometry
                    temp_state = obj.opt_flow_state;
                case 3    %use imu odometry
                    temp_state = obj.imu_state;
                case 4     %use misc odometry
                    temp_state = obj.misc_state;
                case 5     %use misc2 odometry
                    temp_state = obj.misc2_state;
                otherwise
                    temp_state = obj.encoder_state;
            end
                  
            %temp_state is the current position of the robot
            if obj.map.m == 0 || obj.detected_movement(temp_state,obj.map.robot_path(obj.map.m,:)) == 1
                %increment number of robot positions
                obj.map.m = obj.map.m + 1; 
                %save the new state of robot into the map file
                obj.map.robot_path(obj.map.m,:) = temp_state;

                %calculate the position of each obstacle (front 3 sensors)
                for i = 1:3 
                    if (obj.ir_data(i) ~= -1) && (obj.ir_data(i)>250) && (obj.ir_data(i)<400)    %only calculate if an object is seen
                        obj.map.n = obj.map.n + 1; %increment number of obstacles
                        %temp_state(3) is the YAW. Add 72 degrees for side IRs
                        location(1) = temp_state(1)+...
                            obj.ir_data(i)*cos(deg2rad(72*(2-i) +temp_state(3)));
                        location(2) = temp_state(2)+...
                            obj.ir_data(i)*sin(deg2rad(72*(2-i) +temp_state(3)));
                        location(3) = temp_state(3) + 72*(2-i); %save the direction, b/c why not?
                        obj.map.obstacles(obj.map.n,:) = location; %save obst location in Map
                    end
                end
            end
        end
        
        %reset the odometry values
        function odometry_reset(obj)
            obj.imu_state = [0,0,0];
            obj.opt_flow_state = [0,0,0];
            obj.encoder_state = [0,0,0];
%             
            temp = RobotMap; %create new robotMap 
            obj.map = temp;     %save the new map
        end
        
        %calculate sine of current yaw
        function out = sin_(obj)
            out = sin(deg2rad(obj.imu_state(3)));
        end
        %calculate cos of current yaw
        function out = cos_(obj)
            out = cos(deg2rad(obj.imu_state(3)));
        end
        
        %check if robot moved. Returns zero if negligible movement
        function status = detected_movement(obj,pt1,pt2)
            %find change between two points
            dx = abs(pt1(1) - pt2(1));
            dy = abs(pt1(2) - pt2(2));
            dth = abs(pt1(3)- pt2(3));
            %if more than a millimeter or degree has changed, return 1
            if dx > 0.5 || dy > 0.5 || dth > 1
                status = 1;
            else %negligible movement
                status = 0;
            end
        end
        
        %create file to save data into
        function create_file(obj)
            %create file
            obj.filename = strcat(obj.save_path,obj.ID,'_sensor_data',datestr(now,'yy_mm_dd_HH_MM'),'.csv');
            %obj.filename = strcat(obj.ID,'_sensor_data',datestr(now,'yy_mm_dd_HH_MM'),'.csv');
            obj.fileID = fopen(obj.filename,'wt');
            %print first line of names
            fprintf(obj.fileID,'Evobot Gen01 - Sensor Stream, Time Commenced:');
            fprintf(obj.fileID,datestr(clock)); %print time started
            fprintf(obj.fileID,'\n');  %print next line
            for i = 1:length(obj.titles)
                fprintf(obj.fileID,'%s,',obj.titles{i});
            end
            fclose(obj.fileID);
        end
        
        %write all collected data to file %TODO: right now this uses fopen
        %on every write (this is inefficient). fix this somehow. maybe.
        function write_to_file(obj)
            obj.fileID = fopen(obj.filename,'at'); %'at' means 'append'
            if obj.fileID > 0  %if there was no problem opening file
                %print the raw values from robot
                fprintf(obj.fileID,'\n');  %write new line
                for i = 1:length(obj.column)
                    fprintf(obj.fileID,'%s,',num2str(obj.column(i)));
                end
                %TODO: save the path of the robot (new tab in .csv)
                %TODO: save the position of obstacles detected
                fclose(obj.fileID);
            else
                %no save file - do nothing
%                  disp('No save file found...') %(DEBUG MESSAGE)
            end
        end
        
        %close connection with file
        function close_file(obj)
            fclose(obj.fileID);
        end
        
        function delete(obj)
%             fclose(obj.fileID);
            %delete(obj.map);
        end
    end
end