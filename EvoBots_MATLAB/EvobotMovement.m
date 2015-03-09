function out = EvobotMovement (in)
%this function is what commands the robot on what motor action to do, the
%motor action itself is planned by the 'planner' function but 'EvobotMovement'
%is the one that gives the commands over Bluetooth
obj1 = in.s(in.l); %bluetooth connection
%keyboard
fprintf(obj1, '%c', in.R_speed{in.l});
pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(1));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(2));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(3));
% pause(0.1)
% fprintf(obj1, '%c', ';');
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(4));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(5));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(6));
% pause(0.1)
% fprintf(obj1, '%c', ';');
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(7));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(8));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(9));
% pause(0.1)
% fprintf(obj1, '%c', in.R_speed{in.l}(10));
% pause(0.1)
% fprintf(obj1, '%c', ';');
% pause(0.1)
str=fscanf(in.s(in.l))
pause(0.1)
end
