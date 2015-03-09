function [ v1,v2] = mouseVel( mouseData,d_theta,dT,r_track )
%mouseState Takes differential mouse data, and returns x/y coordinate
%states
%Optical Flow pre-filters applied:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise

% r_optical=15; %distance from center of bot to optical flow sensor (m)
% r_track=49/1000; %distance from center of bot to center of track (m)
v1=0;
v2=0;
dist=mouseData.d_y/1000; %filter 2: y component is forward motion, divide by 1000 to get m/s
dv1=dist-d_theta*r_track; %distance travelled by the left track on this timestep
dv2=dist+d_theta*r_track;  %distance travelled by the right track on this timestep
v1=dv1/dT;
v2=dv2/dT;
        
    
    v1(v1<-4 | v1>4)=0; %eliminate physically implausible features
    v2(v2<-4 | v2>4)=0; %eliminate physically implausible features
    

end

