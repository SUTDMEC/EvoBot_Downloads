function [ x,y,theta,thetaP2 ] = mouseState( mouseData,x0,y0,theta0 )
%mouseState Takes differential mouse data, and returns x/y coordinate
%states
%Optical Flow pre-filters applied:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise

x=x0;
y=y0;
theta=theta0;
thetaP2=theta0;
sign=-1;
    mouseData.theta=smooth(mouseData.theta,10);
    for i=1:length(mouseData.d_x)
%             dist=(mouseData.d_x(i)^2+mouseData.d_y(i)^2)^0.5; %assuming that the translation displacement isn't noise
        dist=mouseData.d_y(i); %filter 2: y component is forward motion
        if abs(mouseData.theta(i)) > deg2rad(0.20) && abs(mouseData.theta(i)) < deg2rad(2.5) %filter 1: only consider rotation >1.5
            thetaP2(i+1)=thetaP2(i)+sign*mouseData.theta(i); %theta flipped at 90 (optitrack reference system)
            theta(i+1)=wrapToPi(theta(i)+mouseData.theta(i));
        else
            thetaP2(i+1)=thetaP2(i);
            theta(i+1)=theta(i);
        end
        x(i+1)=x(i)+dist*cos(theta(i+1));
        y(i+1)=y(i)+dist*sin(theta(i+1));

        if abs(thetaP2(i+1))>pi/2
            if thetaP2(i+1)<0
                sign=-1;
            else
                sign=1;
            end
        end
    end
end

