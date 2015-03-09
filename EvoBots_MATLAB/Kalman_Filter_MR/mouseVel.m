function [ v1,v2] = mouseVel( mouseData,theta )
%mouseState Takes differential mouse data, and returns x/y coordinate
%states
%Optical Flow pre-filters applied:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise

% r_optical=15; %distance from center of bot to optical flow sensor (m)
r_track=49/1000; %distance from center of bot to center of track (m)

v1=0;
v2=0;
dT=0.032;

%thetaP2=theta0;
sign=-1;
    for i=1:length(mouseData.d_x)-1
%             dist=((mouseData.d_x(i)./1000)^2+(mouseData.d_y(i)./1000)^2)^0.5; %assuming that the translation displacement isn't noise
        dist=mouseData.d_y(i)./1000; %filter 2: y component is forward motion, divide by 1000 to get m/s
%         if abs(mouseData.theta(i)) > deg2rad(0.5) && abs(mouseData.theta(i)) < deg2rad(10) %filter 1: only consider rotation >1.5 %Try the range 2.5 to 10degree
%             thetaP2(i+1)=thetaP2(i)+sign*mouseData.theta(i); %theta flipped at 90 (optitrack reference system)
%             %theta(i+1)=wrapToPi(theta(i)+mouseData.theta(i));
%             theta(i+1)=(theta(i)+mouseData.theta(i));
%         else
%             thetaP2(i+1)=thetaP2(i);
%             theta(i+1)=theta(i);
%         end
%         dT=time(i+1)-time(i);
        dv1(i+1)=dist-(theta(i+1)-theta(i))*r_track; %distance travelled by the left track on this timestep
        dv2(i+1)=dist+(theta(i+1)-theta(i))*r_track;  %distance travelled by the right track on this timestep
        v1(i+1)=dv1(i+1)/dT;
        v2(i+1)=dv2(i+1)/dT;
        
    end
    
    v1(v1<-4 | v1>4)=0; %eliminate physically implausible features
    v2(v2<-4 | v2>4)=0; %eliminate physically implausible features
end

