function out = stateEstimate ( in )
%This function takes the measurements from the various sensors and
%calculates the pose estimate in various ways

%Data available are:
% left optical
% right optical
% sensors (IMU, IR sensors)
% images
% in.optical_flow - flag set to determine if optical flow algorithm is run


%% Perform optical flow

% if in.optical_flow
%     % to do - include estimate of optical flow based on KTTI work
%     %take pic sync
%     out_optical = EvoOptical(in);
%     %out_optical.dx - change in x
%     %out_optical.dy - change in y
% end


%% Estimate trajectory based on optical
% saving the previous left optical and right optical position
in.previous_l_position{in.n}=in.prev_left_optical{in.n};
in.previous_r_position{in.n}=in.prev_right_optical{in.n};

%input to optical theta:  left and right optical dx dy
out_optical = optical_theta (in);
out.heading_difference=out_optical.heading_difference;
out.mice_state.x= out_optical.mice_x; %- vector of new optical x
out.mice_state.y= out_optical.mice_y; %- vector of new optical y
out.mice_state.theta= out_optical.mice_theta;% - vector new optical theta
out.mice_state.previous_left{in.n}=out_optical.previous_l_position{in.n};
out.mice_state.previous_right{in.n}=out_optical.previous_r_position{in.n};


% to be removed later only for debugging, plotting the optical movement data
out.l_optical_movement=out_optical.l_optical_movement;
out.r_optical_movement=out_optical.r_optical_movement;

%% Estimate trajectory based on IMU

% out_IMU = IMU_state(in);
% %% fuse the sensor data
% %only the sensor da
% IMUstate.x=out_IMU.x.*100; %in CM
% IMUstate.y=out_IMU.y.*100; %in CM
% IMUstate.theta=out_IMU.theta.*100; %in CM
% out.IMUonly=IMUstate;
% keyboard
%Best estimate of x and y position
out.x=out.mice_state.x; %in CM
out.y=out.mice_state.y; %in CM
out.theta=out.mice_state.theta; %in CM

end