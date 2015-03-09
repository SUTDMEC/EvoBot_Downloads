function [ out ] = plotRun( in )
%plotRun Displays the output of a run graphically
%   Takes: in.synch_data which is the synched data for the run
%          in.state_out which is the state estimate for the run

% figure
scatter(in.x{in.n},in.y{in.n},'b')%Plotting the path travelled by the robot
hold on
scatter(in.map_out{in.i}.landmark_x_location,in.map_out{in.i}.landmark_y_location,'r')% plotting the obstacle path
hold on
axis([-500 3000 -500 3000])
grid on
legend({'Path', 'Obstacle'});
title('Environment+path Data');
end

