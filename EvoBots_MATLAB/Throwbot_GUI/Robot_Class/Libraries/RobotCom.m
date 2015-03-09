%% This object handles the communication with the robots
% The robot ID must be known (What matlab should look for over COMM ports)

classdef RobotCom < handle
    
    properties (SetAccess = private, GetAccess = private)
        
    end  %/private properties
    properties (SetAccess = public, GetAccess = public)
        Robot_ID
        data = RobotData %raw data from robot
        s          %bluetooth connection
        str = ''
        bt_connection = 0   %set this to 1 if BT is connected
    end %/public properties
    
    methods
        %constructor
        %         function obj = RobotComm(obj,robot_id)
        %             obj.Robot_ID = robot_id;
        %         end
        function obj = ssetID(obj,robot_id,robot_s)
            
            obj.Robot_ID = robot_id;
            obj.s= robot_s;
            %            fprintf('%s',obj.Robot_ID)
        end
        
        %Use Abhishek's code to connect to the robots
        function status = connect(obj)
            %Returns 0 if connection failed
            dum = 4;
            %             obj.s = Bluetooth(obj.Robot_ID,1); %Setting the bluetooth port for each robot
            while obj.bt_connection~=1 
            try
                fopen(obj.s);
                fprintf(['\n' obj.Robot_ID ' configured']);
                obj.bt_connection = 1;
                set(obj.s,'Timeout',0.1);
                status = 1;
                warning('off','instrument:fscanf:unsuccessfulRead')
            catch
                fprintf(['\n' obj.Robot_ID ' Bluetooth connection failed.'])
                status = -1;
                obj.bt_connection = -1;
                disp('Reconnecting to robot...')
            end
            end
        end
        
        %send command
        function status = write_cmd(obj,string)
            %send command to robot
            %maybe use a "KEYBINDINGS.txt" for command list?
            
            if obj.bt_connection == 1
%                 crc_gen=CRC16(string);
%                 string2send=strcat(string,crc_gen);
               
                fprintf(obj.s, '%s', string);
               
                status = 1;
            else
                %fprintf(['\n' obj.Robot_ID ' not connected'])
                status = 0;
            end
        end
        
        %read from robot (should be called all the time)
        function status = read(obj)
            %return -1 if nothing is available (don't block)
            %call "Archive" from here to save all data
            if obj.bt_connection == 1
                try
%                     entered_try=11
                    
                    obj.str = CRC_testing(obj.s); %read from bluetooth
                    
%                     entered_aft_crc=1;
                    if length(obj.str)  < 1     %check if string is empty
                        status = -1;
                    else
                        status = 1;     %string contains data
                    end
                catch
                    a=lasterror
%                     status = lasterror
                end
            else
                %fprintf([obj.Robot_ID ' not connected'])
                status = -2
            end
        end
        
        %Call this before befor destroying class
        function delete(obj)
            delete(obj.s);
            %             fclose('all');
        end
        
    end  %/methods
    
end  %/class
