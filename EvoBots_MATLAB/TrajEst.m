function [ x,y,theta,thetaP2 ] = TrajEst(x0,y0,theta0,senseTime,mouseData,IMUData,PowerData,encoderData,ct_vec,param, mode )
%% The TrajEst function estimates pose and trajectory from mouse, IMU, and
%power models
%   outputs vectors of common time, x, y, and theta (where angle wraps at pi), and thetaP2(where angle wraps around Pi/2 as in the optitrack) for validation against
%   ground truth.
% mode switch determines which signals to use in the state estimation
    %available fusion modes:
    %all = use all measurements
    %mouse= only use optical flow
    %mousemod= use optical flow and model
    %IMU=only use IMU
    %IMUmod=use IMU and model
    %mod=only use model
    %encoder
    %encodermod
    
%Pre-filters applied: 
%Optical Flow:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise


try
%% Trajectory Estimation
Current = param.curr_gain .* PowerData.Current + param.curr_offset; %corrected to account for IR sensor draw in current calculation
%set the first value in the state vectors equal to the initial positions
switch mode
    case 'mouse'
       %calculate the robot translation and rotation from the mouse based
       %on the old format where the mouse sent raw values for the left and
       %right encoder
     
        %now the mouse data is the dy (forward) and dx (translation) and dyaw pre-calculated
        [ x,y,theta,thetaP2 ] = mouseState( mouseData,x0,y0,theta0  );
    case 'encoder'
        [x,y,theta,thetaP2]=encoderFlow(encoderData,x0,y0,theta0);
    case 'mousemod'
        [x,y,theta,thetaP2]=mouseEKF2( mouseData,ct_vec,senseTime,x0,y0,theta0);%This works by fusing the optical flow data with the robot model
    case 'encodermod'
        [x,y,theta,thetaP2]=encoderEKF( encoderData,ct_vec,senseTime,x0,y0,theta0);%to be done
    case 'IMU'
%         To be done;
    case 'IMUmod'
%         To be done;
    case 'mod'
        [x,y,theta,thetaP2]=modelOnly(ct_vec,senseTime,x0,y0,theta0,IMUData);%This estimates the states using only the model
    case 'all'
        [x,y,theta,thetaP2]=sensorFuse(mouseData,encoderData,ct_vec,senseTime,x0,y0,theta0);%To be done
end

catch
    a=lasterror
    b=a.message
    keyboard
end

end

