function out = moveEvoBot (in)
%this function is what commands the robot on what motor action to do, the
%motor action itself is planned by the 'planner' function but 'moveEvoBot'
%is the one that gives the commands over Bluetooth
for l=1:in.robot_num
    in.l=l;
    EvobotMovement(in);
end
end
