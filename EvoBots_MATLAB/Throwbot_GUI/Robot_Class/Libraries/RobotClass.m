classdef RobotClass < handle
    %RobotClass Contains everything used to control robot
    % addID('string') - add a robot ID to connect to
    % removeID('string') - remove specified robot ID
    % connectRobots()   - connect to all specified robot IDs.
    % write(robot#,'string') - sends message 'string' to the selected robot
    % update()  - Call this often. Reads and saves robot data. Saves map.
    % Update_Map(robot#,figure_handle)  - plots robot#'s map to the figure
    %       specified. If no handle is given, plot to active figure.
    % calibrate()       - calibrates all robots (not complete)
    % stop()            - stops the timer 't' (to be removed)
    %   <insert list of functions>
    
    properties
        i=0           %number of robots
        bt =  RobotCom  %robot communication objects (list)
        data = RobotData %current robot data (list)
        robot_ids       %list of robot IDs to use (list)
        s  % bluetooth Initialization details
        gui_h           %handle for the GUI (TODO: REMOVE THIS)
        axesHandle    %handle for GUI axis
        mapx=0;
        mapy=0;
        prev_temp_r='1';
        prev_temp_l='1';
        prev_time='0';
        stop_flag = zeros(1,15); %stop flag for each robot
        map_update_flag = 0; %flag to indicate if map should be updated
        t  %probably won't use this timer
        selected=1;   %select which robot to plot
    end
    
    methods
       
        function Update_Map(obj,r_num,map_handle)
            %r_num is the robot number you'd like to display
            %map_handle is the handle to the figure in which map is
            %displayed (used for GUI). Leave blank and it will plot to
            %currently active figure.
            
            %check if robot is within the range of available robots
            if r_num > obj.i  %if r_num is greater than the number of robots
                %do nothing
            elseif obj.bt(r_num).bt_connection ~= 1 %if there is no bluetooth connection
                if nargin == 3 && ishandle(map_handle) %if all arguments were passed in and handle is valid, plot to specified map handle
                    scatter(map_handle,42,42);  %plot a default figure to map_handle
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                    
                else
                    scatter(2,2); %if no map handle was passed in, plot default figure
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                end
            elseif r_num == 0 %if no robots were selected, do nothing
                scatter(1,1); %plot default figure
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
            elseif r_num ~= -1  %if ALLROBOTS was not selected, update map for one robot
                path = obj.data(r_num).map.robot_path(:,1:2);     %take only (x,y) components
                obstacles = obj.data(r_num).map.obstacles(:,1:2); %take only (x,y) components 
                
                if nargin == 3 && ishandle(map_handle) %if all arguments were passed in, plot to specified map handle
                    scatter(map_handle,path(:,1)+xpos,path(:,2)-ypos,'RED');
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                    hold on
                    scatter(map_handle,obstacles(:,1)+xpos,obstacles(:,2)-ypos,'BLUE');
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                    hold on
                else  %plot to current figure
                    
                    
                    load prev_run.mat  %load the previous run configuration file
                    for ii=1:length(bt)
                        strpos=[];
                        strpos=findstr(char(bt.Name(ii)),char(obj.robot_ids));%check which robot is active at this current moment
                        if length(strpos)>0
                            break %ii is the robot number
                        end
                    end
                    
                    xpos=1000*pos{ii}(1);%position in mm
                    ypos=1000*pos{ii}(2);%position in mm

                    scatter(path(:,1)+xpos,path(:,2)-ypos,'RED');
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                    hold on
                    scatter(obstacles(:,1)+xpos,obstacles(:,2)-ypos,'BLUE');
                    xlabel('x distance in mm')
                    ylabel('y distance in mm')
                    axis([-1200 1200 -1200 1200])
                    hold on
                end
            else 
            end
        end
        % add a robot ID to the robot_ids
        function status = addID(obj,str,str1,robot_number)
            % check if ID has already been set
            match = 0;    %set this to 1 if the ID matches a current ID
            for i = 1:obj.i
                if size(str) == size(obj.robot_ids{i})
                    if str == obj.robot_ids{i}
                        match = 1;
                        status = 0;
                    end
                end
            end
            %if it is a new ID, increment i and add ID
            if match == 0
                obj.i = obj.i+1;  %increment the number of robots
                temp = RobotCom;  %declare a new RObotCom handle
                obj.bt(obj.i) = temp; %save the handle to bt
                obj.bt(obj.i).ssetID(str,str1); %save the new robot ID in RobotCom
                obj.robot_ids{obj.i} = str; %save the new robot ID in RobotClass
                temp = RobotData;    %declare new RobotData handle
                obj.data(obj.i) = temp; %save RobotData handle to data array
               % obj.data(obj.i).ID=str;
                obj.data(obj.i).ID = strcat(num2str(robot_number),'_',str); %save new robot ID in RobotData
                
                status = 1;
            end
        end
        function status = removeID(obj,str)
            match = 0;
            %if input is nothing, remove all IDs
            status = nargin;
            if nargin == 1
                obj.i = 0;  %set number of robots to zero
                obj.robot_ids = {0};
                for i = 1:obj.i
                    obj.bt(i).delete;
                end
            else %if check if str matches something
                %scan through all robots
                for i = 1:obj.i
                    %check if string size is the same
                    if match == 0
                        if length(str) == length(obj.robot_ids{i})
                            %check if string is the same
                            if str == obj.robot_ids{i}
                                %found matching robotID. Delete it
                                match = 1;
                                %if it is not the last robot,shift the next robotID down
                                if i ~= obj.i
                                    obj.robot_ids{i} = obj.robot_ids{i+1};
                                    obj.bt(i) = obj.bt(i+1);
                                else %if it is the last robot, delete it
                                    obj.robot_ids{i} = '';
                                    delete(obj.bt(i)); %delete the bluetooth object
                                end
                            end
                        end
                    else %shift the rest of the robotIDs down
                        if i == obj.i %if it is the last one, delete it
                            obj.robot_ids{i} = '';
                            obj.bt(i) = RobotCom ;
                        else
                            obj.robot_ids{i} = obj.robot_ids{i+1};
                            obj.bt(i) = obj.bt(i+1);
                        end
                    end
                end
                if match == 1 %if something was deleted, decrement # of robots
                    obj.i = obj.i - 1;
                end
            end
        end
        
        %connect all robots
        function status = connectRobots(obj)
            for i = 1:obj.i  %run for each robot
                if obj.bt(i).bt_connection < 1 %if not already connected
                    status(i) = obj.bt(i).connect;     %try to connect robot
                end
            end
        end
        
        %write to the specified robot
        function write(obj,robotNumber,str)
            if nargin == 2  %if only one parameter is passed in, write to selected robot
                str = robotNumber;
                robotNumber = obj.selected;
                obj.bt(robotNumber).write_cmd(str);
            elseif robotNumber == -1  %write to all robots
                for i = 1:obj.i
                    obj.bt(i).write_cmd(str);
                end
            else   %both parameters were passed in properly
                obj.bt(robotNumber).write_cmd(str);
            end
        end
        
        %returns the list of robot IDs currently saved
        function robotIDs = listID(obj)
            robotIDs = obj.robot_ids;
        end
        
        %Call this function every iteration. Updates values from robot.
        function status = update(obj)
            method = 2;   %select the odometry method used to calculate obstacle location
            %             axis([-500 500 -500 500]); %TODO: change axis limits
            %             hold on;
            status = zeros(15);
            %Update each robot
            for i = 1:obj.i
                if obj.bt(i).bt_connection == 1  %if bluetooth is connected, read from it
                    %tic
                    status(i) = obj.bt(i).read();
                    %toc
%                     exit_read=1
                else
                    status(i) = -2; %indicates BT is disconnected
                    break;
                end
                
                %separate the string into data
                if status(i) > 0
                    %splid data by ';', save into temp variable
                    received_string=obj.bt(i).str;
                    temp = strsplit(received_string,';');
                    l = length(temp) -1; %subtract 1 to remove the '\n' at end of line
                    
                    %if length is long enough (specified in 'RobotData'), save all data
                    if l > obj.data(i).n
                        %calculate length of timestep                       
                        if(str2num(temp{15})==0 && str2num(temp{16})==0 && str2num(temp{6})<270 && str2num(temp{6}) ~= -1)%IF the robot moves for the set duration
                           % if(str2num(obj.prev_temp_l)~=0 && str2num(obj.prev_temp_r)~=0 || (str2num(temp{2})-str2num(obj.prev_time))>3000)
                           if ((str2num(temp{2})-str2num(obj.prev_time))>2000)     
                                obj.stop_flag(i) = 1;
                                % obj.bt(i).write_cmd(received_string);
                                obj.prev_time=temp{2};
                                obstacle=1;
                                status(i) = 0;
                               
                           end
                        %elseif(str2num(temp{15})==0 && str2num(temp{16})==0 ) % if the robot sees an obstacle in between
                            %if(str2num(obj.prev_temp_l)~=0 && str2num(obj.prev_temp_r)~=0 || (str2num(temp{2})-str2num(obj.prev_time))>10000)
                        elseif((str2num(temp{2})-str2num(obj.prev_time))>1)
                                obj.stop_flag(i) = 1;
                                %obj.bt(i).write_cmd(received_string);
                                obj.prev_time=temp{2};
                                status(i) = 0;
                            %end
                        end
                        obj.prev_temp_l = temp{15};
                        obj.prev_temp_r = temp{16};
                       
                        
                        if(obj.data(i).time == 0) %for the first sample, set dt to 0
                            obj.data(i).dt = 0;
                        elseif str2num(temp{2}) > obj.data(i).time;  %make sure time increased
                            obj.data(i).dt =  str2num(temp{2}) - obj.data(i).time;
                        end
                        
                        if str2num(temp{2}) > obj.data(i).time;
                            obj.data(i).time = str2num(temp{2});
                        end
                        
                        %copy all the data
                        for(j = 1:obj.data(i).n)
                            %convert string to number, ignore the first value (&)
                            try
                                obj.data(i).column(j) = str2num(temp{j+1});
                            catch
                                line_210_format_error = 1
                            end
                        end
                        obj.data(i).write_to_file; %save the data to the file
                        %calculate power used in that step (in mAh)
                        used = obj.data(i).column(2)*(obj.data(i).dt /1000/60/60);
                        obj.data(i).power_drain = used + obj.data(i).power_drain;
                        
                        %calculate new position of robot
                        obj.data(i).odometry;
                        
                        %add obstacles detected and robot path to map
                        obj.data(i).position_on_map(method);
                        
                        
                    elseif l == 2 || l == 3
                        %if length is not long enough (didn't receive full sensor
                        %data), check if the 'stopped' or 'obstacle' flag were set
                        %if stopped or obstacle flag are set, send the robot a
                        %new command
                        
                        %else discard this data - missed a semicolon. Increment
                        %missed data count
                        status(i) = 0;
                    else %do nothing if less than two data has been received
                    end
                end
            end
            %            hold off;
        end
        
        %calibrate each robot - not finished only does yaw (TODO)
        function calibrate(obj)
            stat = zeros(1,obj.i);
            count = 0;
            for i = 1:obj.i %cycle through all robots
                if obj.bt(i).bt_connection == 1 %if bt is connected, continue
                    obj.write(i,'A'); %query all data from robot
                    %Commented on 18 Oct 2014%%pause(0.5);
                    stat(i) = 0;
                    while stat(i) == 0 && count < 10 %while no data is read, loop.
                        stat = obj.update; %(error will make stat = -1, success stat = 1, no data stat = 0)
                        count = count + 1; %increment counter as timeout in case robot connection is valid but sends nothing
                    end
                    obj.data(i).yaw_offset;  %set the yaw offset
                    obj.data(i).odometry_reset; %reset odometry
                    
                    %(TODO) Read from 'robotID'.txt file to get scaling
                    %parameters
                    %write the scaling parameters into the RobotData object
                end
                %open a config file for each robot?
                obj.data(i).odometry_reset; %reset odometry
            end
        end
        
        function stop(obj)
            stop(obj.t);
        end
        
        %set the savepath for the robots
        function set_savepath(obj,str,robot_num)
            if nargin == 2  %if only one is passed in, apply to all robots
                for i = 1:obj.i
                    obj.data(i).save_path = str;
                end
            elseif nargin == 3 %if two values passed in, apply to selected robot
                obj.data(robot_num).save_path = str;
            end
        end
        
        %close all save files (not used)
        %         function close_savefiles(obj)
        %             obj.data.close_file
        %         end
        
        %destructor
        function delete(obj,str)
            warning('on','instrument:fscanf:unsuccessfulRead')
            obj.bt.delete;
            delete(obj.data);
            %             delete(tt);
            fclose('all');
        end
        
        function unhookBT(obj)
            for i = 1:obj.i
                fclose(obj.bt(i).s);
                obj.bt(i).s = 0;
            end
        end
    end
    
end

