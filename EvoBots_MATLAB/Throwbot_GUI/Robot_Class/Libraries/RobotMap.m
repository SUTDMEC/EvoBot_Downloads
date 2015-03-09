classdef RobotMap < handle
    properties
        n = 0;      %n is the number of obstacles
        m = 0;      %m is the number of robot positions on map
        time =0;    %Timestamp of each robot (corrected to computer's time)
        dt=0;          %time since last sample
        obstacles=[0,0,0];      %obstacles detected by each robot
        robot_path=[0,0,0];     %path of each robot
    end
    methods
    function delete(obj)
        fclose('all');
    end
    end
    
end