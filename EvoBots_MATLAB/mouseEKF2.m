function [xout,yout,thetaout,thetaP2]=mouseEKF2( mouseData,ctrvec,senseTime,x0,y0,theta0)

try
%%This function applies an extended Kalman filter to perform sensor fusion
%on the evobots data
%Optical Flow ipre-filters applied:
%1. if mouseData.theta<deg2rad( const ) then the rotation is considered noise
%2. forward motion only comes from the dy component, dx is lateral motion and hence noise
%3. smoothing of mouseData.theta using a rolling average filter with span = constant
%4. if mouseData.theta>deg2rad(cost) it is also noise

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
dT=mean(diff(movetime));%mean of this time
if isnan(dT)
    dT=0.029;
elseif dT>0.035
    dT=0.03;
end
% dT=0.03;

%from the data, time seperation:
%initialize state-vector
% T=0.032;
% nStates=8;
nStates=6;

xV = zeros(nStates,length(mouseData.d_x));%x(7,:)=xpos x(8,:)=ypos x(9,:)=theta
% xV(5,1)=theta0;
% xV(7,1)=x0;
% xV(8,1)=y0;
% %xV(9,1)=theta0;
% x(1:6)=0;

x(1)=x0;
x(2)=y0;
x(3)=theta0;

x=x';
% xV
% x
%x(9)=theta0;

thetaP2=theta0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Motion equations %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Previous state (initial guess): Our guess is that the train starts at 0 with velocity
% that equals to 50% of the real velocity
Xk_prev = [0; 
    0; 
    0;
    0;
    0;
    0;];

% Current state estimate
Xk=[];

% Motion equation: Xk = Phi*Xk_prev + Noise, that is Xk(n) = Xk(n-1) + Vk(n-1) * dt
% Of course, V is not measured, but it is estimated
% Phi represents the dynamics of the system: it is the motion equation
% Phi = [1 dt;
%        0  1];
%x(5)=180*x(5)/pi;
U=[ctrvec, 100*ones(1,length(ctrvec))']/100;
U=U';

%state space representation.

%input: previous state x, control vector u, and time step size t (deltaT)

%modified by E.W.

%%  Based on this model formulation, the below discrete model was generated
%Input Parameters
% 
V=5;%Battery Voltage
% ratio=3.8/5;
% 
% %%%%%%%%%%%%%%%Change this to control robot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% left_PWM=U(1);%Set these to values between -1 and 1
% right_PWM=U(2);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% u1=ratio/left_PWM;%Maximum is 3.8/5 min is 37
% u2=ratio/right_PWM;
% 
% % u1=eff_volt*left_PWM;%Maximum is 3.8/5 min is 37
% % u2=eff_volt*right_PWM;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%Educated guesses%%%%%%%%%%%
m=0.26;%lumped mass. More than actual mass to compensate for moment of inertia
G=1/100;%Gear Ratio
r=0.02;% Wheel Radius
l=0.2;%Length is not actual length of bot. Compensation for moment of inertia
L=0.0015;% Inductance of motors
%%%%%%%%%%%Wild (but realistic) Guesses%%%%%%%%%%%%%%%
Rp=21;% Parasitic Resistance
R=2;%motor winding resistance, Increase causes Reduction in velocity, reduction in current
Rb=0.5;%Battery internal resistance
Rc=1;%Damping constant corresponding to coupling of the two side
%ugy=0.005; %K value of motor. Decreasing this increases current and marginally increases vel
Rf=21;% Damping constant related to frictional effects. Increasing this inc the currents, reduces velocity
Lp=0.0001;%Parasitic Inductance
%K12=1/100000;% Coupling stiffness
K=0.005; %V/rad/s
% 
% 
% trackDistance=98; %98 mm displacement between CoM of the treads
% %%%%%%%%%%%%%%%%%%%%%%
% 
A=[-R/L ,  0 , -K/(G*r*L) , 0 , 0 , 0;
   0 ,   -R/L ,  0  , -K/(G*r*L) ,  0 ,  0;
   2*K/(G*r*L) ,   0 ,  (-2*Rf)/m , 0  , 0 ,  0;
   0  ,  2*K/(G*r*m)  , 0 ,  (-2*Rf)/m ,  0  , 0;
   0  ,  0  , 1/l ,  -1/l ,  0 ,  0;
   0  ,  0  , 0 ,  0 ,  0  , -Rp/Lp;];
% 
B=[ V/L,0,0;
    0,V/L,0;
    0,0,0;
    0,0,0;
    0,0,0;
    0,0,V/Lp;];

C=[0,0,0,0,0,0];

D=[0,0,0];

sys = ss(A,B,C,D);
% 
sysd= c2d(sys,dT); %0.022 comes from the mean sample time of all
% measurements

%The state vector = x, received after integration from the solver, at this instant.

%% This model results after discrtization of Thommen's robot model
A=sysd.a;
B=sysd.b;

%%A=[1.22e-10,0,-3.463e-13,0,0,0;0,-9.01e-11,0,4.382e-10,0,0;6.927e-13,0,1.221e-10,0,0,0;0,-8.763e-12,0,-1.227e-10,0,0;0.000399910481226157,-0.000391236252982333,1.59964191297059e-05,-0.00156494490662714,1,0;0,0,0,0,0,0];


%%B=[  0.0005599,0,0;0,0.05477,0;0.2,0,0;0,0.1956,0;0.04265,-0.0414,0;0,0,0.2381];
if ~iscolumn(x) %retranspose for initial conditions sizing error
    x=x';
end

% The error matrix (or the confidence matrix): P states whether we should 
% give more weight to the new measurement or to the model estimate 

%initialize P, the Covariance Prediction
sigma_model = 1;
% P = sigma^2*G*G';
P = eye(6)*sigma_model;
% 
% [sigma_model^2, 0             0;
%     0,sigma_model^2,0;
%                  0,0, sigma_model^2];

% Q is the process noise covariance. It represents the amount of
% uncertainty in the model. 

sigma_noise = 0.001;
Q = eye(6)*sigma_noise;
% [sigma_noise^2, 0, 0;
%     0, sigma_noise^2, 0;
%      0, 0, sigma_noise^2];
 
% M is the measurement matrix. 
% We measure X, so M(1) = 1
% We do not measure V, so M(2)= 0
%state 3=left motor, state 4=right motor, state 5 = theta
H = [0,0,1,1,1,0];

% R is the measurement noise covariance. Generally R and sigma_meas can
% vary between samples. 
sigma_meas = 1; % rad
R=sigma_meas^2;
% R = Q;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kalman iteration %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Buffers for later display
Xk_buffer = zeros(nStates,length(U));
Xk_buffer(:,1) = Xk_prev;
K_buffer=zeros(nStates,length(U));

%initialize the measurement input vector
[ vxm,vym,thetam,thetaP2m ] = mouseVel( mouseData,theta0,dT );
% ddd=sum(vxm'+vym')*dT/2


% initialize the measurement vector with the states 'measured' by the mouse
zV = [zeros(1,length(vxm(2:end))); zeros(1,length(vxm(2:end))); vxm(2:end);vym(2:end);(thetam(2:end))'; zeros(1,length(vxm(2:end)))]; % scale by 1000 to m from mm, and remove first element which is the initial position
% plot(thetam*180/pi)
% pause

for k=1:length(U)-1
    
    % Z is the measurement vector. In our
    % case, Z = TrueData + RandomGaussianNoise
    Z = zV(:,k);
    
%     Xk = A*Xk_prev; % state prediction, to figure out where we're going to be

    Xk=A*Xk_prev+B*U(:,k);%;0;0;0];
    
    % Kalman iteration
    P1 = A*P*A' + Q; %covariance prediction
    
    y=Z-H*Xk; %innovation - compare reality with prediction
    
    S = H*P1*H' + R; %innovation covariance (compare real error with prediction)
    
    % K is Kalman gain. If K is large, more weight goes to the measurement.
    % If K is low, more weight goes to the model prediction.
    K = P1*H'*inv(S);
%     K=K'; %hack - should determine real R...

    Xk =  Xk + K'*y; %state update (previous state + K update)
%Xk=Xk;
%     P=P1-K*H*P1;
     P = (eye(nStates) - K*H)*P1; % covariance update (new estimate of error)
    
    Xk_buffer(:,k+1) = Xk;
    K_buffer(:,k)=K;
    % For the next iteration
    Xk_prev = Xk; 
end;


Xk_buffer(5,:)=thetam(1:length(Xk_buffer(5,:)));
% vx=((dx(3)+dx(4))*cos(dx(5)))/2;
% vy=((dx(3)+dx(4))*sin(dx(5)))/2;
v=(Xk_buffer(3,:)+Xk_buffer(4,:))./2;
% vx=((dx(3)+dx(4))*cos(dx(5)))/2;
% vy=((dx(3)+dx(4))*sin(dx(5)))/2;
%w=(dx(3)-dx(4))/l; %not necessary in new state space representation
% dx(5)=0;

dx=v.*dT.*cos(Xk_buffer(5,:));
xout=cumsum(dx)';
dy=v.*dT.*sin(Xk_buffer(5,:));
yout=cumsum(dy)';
% plot((180/pi)*Xk_buffer(5,:))
% pause
% thetaout=cumsum(xV(5,:))';%theta

thetaout=(xV(5,:))';%theta
thetaout=Xk_buffer(5,:)';
% plot(thetaout)
% pause
% thetaP2=thetaout;
thetaP2  = Conv2P2( thetaout ); %wrap at 90deg instead of 180
%thetaout=wrapToPi(thetaout);
thetaout=(thetaout);

catch err
    a=lasterror
    b=a.message
    keyboard
end

end