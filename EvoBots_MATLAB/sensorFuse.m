function [xout,yout,thetaout,thetaP2]=sensorFuse( mouseData,encoderData,ctrvec,senseTime,x0,y0,theta0)

try
%%This function applies an extended Kalman filter to perform sensor fusion
%on the evobots data
%Optical Flow ipre-filters applied:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise

%initialize the model function
f = @EvoBotModel_2;
% f= @statupd;
%initialize measurement vectors
h = @measupd_mouse; %three measurements: v1, v2, (not vx, vy) theta
%time resolution - for now the average difference in time-step for the
%sensor time values
T=mean(diff(senseTime));
%initialize state-vector

nStates=9;

xV = zeros(nStates,length(mouseData.d_x));%x(7,:)=xpos x(8,:)=ypos x(9,:)=theta
xV(5,1)=theta0;
xV(7,1)=x0;
xV(8,1)=y0;
xV(9,1)=theta0;
x(1:6)=0;
x(5)=theta0;
x(7)=x0;
x(8)=y0;
x(9)=theta0;


thetaP2=theta0;

% Initialize Meaurement noise covariance matrix
% What standard deviations we expect in different measurements
snx = 1;
sny = 1;
sntheta = 1;
R = diag([snx^2 sny^2 sntheta^2]);


% Process noise covariance matrix
% r = 1;
% Q = 5*diag([snx^2 sny^2 sntheta^2]);
Q = eye(nStates);
% Q = Q + 0.1;
Q = 1*Q;

% Initial state error covariance matrix
% p = 10*r;
% P = p^2*eye(n);
P = 10*Q;

%initialize the control input vector
u=ctrvec'; %with u(1,:)=left motor command u(2,:)=right motor command

%from the data, time seperation:
dT=0.02;

[ vxm,vym,thetam,thetaP2m ] = mouseVel( mouseData,theta0,dT ); 

ms.vx=vxm;
ms.vy=vym;
ms.theta=thetam;

[vxe,vye,thetae,thetaP2e]=encoderVel(encoderData,theta0,dT );

en.vx=vxe';
en.vy=vye';
en.theta=thetae';


%select a certain number of points from each measurement steam and splice
%them into the measurement vector

%Note, if nEcode > nMouse, the fraction of the ratio multiplied by 10 is used
nMouse=1; %the number of mouse samples before an encoder sample is chosen
nEncode=1;
% [vx,vy,theta]=spliceSense(ms,en,nMouse,nEncode,'sample'); % to use sampling
[vx,vy,theta]=spliceSense(ms,en,nMouse,nEncode,'average'); %to average measurements

% keyboard

% initialize the measurement vector with the states 'measured' by the mouse
zV = [vx(2:end);vy(2:end);theta(2:end)]; % scale by 1000 to m from mm, and remove first element which is the initial position
% keyboard
%run the Extended Kalman Filter through all of the measured states
% figure
% hold on
for i=1:length(mouseData.d_x)-1
%     plot(i,cond(P),'*r');
%     plot(x(7),x(8),'*')
%     keyboard
    [x, P] = ekfwu(f,x,P,h,zV(:,i),Q,R,u(:,i),T);          % ekf 
    xV(:,i+1) = x;                                         % save estimate i+1 since initial value is x0,y0,theta0
end
xV=xV';

xout=xV(:,7); %x position
yout=xV(:,8); %y position
thetaout=xV(:,5); %theta
% thetaP2=thetaout;
 thetaP2  = Conv2P2( thetaout ); %wrap at 90deg instead of 180

catch
    a=lasterror
    b=a.message
    keyboard
end

end