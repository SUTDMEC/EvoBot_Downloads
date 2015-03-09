function [xout,yout,thetaout,thetaP2]=mouseEKF( mouseData,ctrvec,senseTime,x0,y0,theta0)

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
%Automatically find the sampling time
%Need this because sampling time when robot moves is different from when robot is stationary
for i=1:length(ctrvec)
     move=find(ctrvec~=0); %Find which rows of data correspond to the robot motion
end
for i=1:length(move)
    deltamove=move(i+1)-move(i);%Check if the robot motion data is continuous
    if deltamove>1%If it is not continuous, then break out from the loop
        endmove=i;
        break
    end
end

movetime=senseTime(move(1):move(endmove));%Time data for which the robot moves. 
T=mean(diff(movetime));%mean of this time
dT=T;
%initialize state-vector
% T=0.032;
nStates=8;

xV = zeros(nStates,length(mouseData.d_x));%x(7,:)=xpos x(8,:)=ypos x(9,:)=theta
xV(5,1)=theta0;
xV(7,1)=x0;
xV(8,1)=y0;
%xV(9,1)=theta0;
x(1:6)=0;
x(5)=theta0;
x(7)=x0;
x(8)=y0;
% xV
% x
%x(9)=theta0;

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
dT=0.032;

[ vxm,vym,thetam,thetaP2m ] = mouseVel( mouseData,theta0,dT );
% ddd=sum(vxm'+vym')*dT/2


% initialize the measurement vector with the states 'measured' by the mouse
zV = [vxm(2:end);vym(2:end);(thetam(2:end))']; % scale by 1000 to m from mm, and remove first element which is the initial position

%run the Extended Kalman Filter through all of the measured states
% figure
% hold on
for i=1:length(mouseData.d_x)-1
%     plot(i,cond(P),'*r');
%     plot(x(7),x(8),'*')
%     keyboard

    [x,P] = ekfwu(f,x,P,h,zV(:,i),Q,R,u(:,i),T);

    % ekf 
    xV(:,i+1) = x;                                         % save estimate i+1 since initial value is x0,y0,theta0
end
xV=xV';
xout=xV(:,7); %x position
yout=xV(:,8); %y position
thetaout=xV(:,5);%theta

%pause
% thetaP2=thetaout;
 thetaP2  = Conv2P2( thetaout ); %wrap at 90deg instead of 180
%thetaout=wrapToPi(thetaout);
thetaout=(thetaout);
catch
    a=lasterror
    b=a.message
    keyboard
end

end