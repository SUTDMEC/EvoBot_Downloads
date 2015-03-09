function  [out] = EvoBotModel_2(x,U,t)
try
format long
%based on T. George's 'test_ode5' model, in the 'With PWM,Slip and parasitic effects' folder,
%11.July,2014
%x(5)=180*x(5)/pi;
U=U/100;
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
m=0.15;%lumped mass. More than actual mass to compensate for moment of inertia
G=1/100;%Gear Ratio
r=0.02;% Wheel Radius
l=0.15;%Length is not actual length of bot. Compensation for moment of inertia
L=0.0015;% Inductance of motors
%%%%%%%%%%%Wild (but realistic) Guesses%%%%%%%%%%%%%%%
Rp=21;% Parasitic Resistance
R=2;%motor winding resistance, Increase causes Reduction in velocity, reduction in current
Rb=0.5;%Battery internal resistance
Rc=1;%Damping constant corresponding to coupling of the two side
%ugy=0.005; %K value of motor. Decreasing this increases current and marginally increases vel
Rf=7;% Damping constant related to frictional effects. Increasing this inc the currents, reduces velocity
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
sysd= c2d(sys,t); %0.022 comes from the mean sample time of all
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


dx=A*x(1:6)+B*[U(2);U(1);1];%;0;0;0];
% vx=((dx(3)+dx(4))*cos(dx(5)))/2;
% vy=((dx(3)+dx(4))*sin(dx(5)))/2;
v=((dx(3)+dx(4)))/2;
% vx=((dx(3)+dx(4))*cos(dx(5)))/2;
% vy=((dx(3)+dx(4))*sin(dx(5)))/2;
%w=(dx(3)-dx(4))/l; %not necessary in new state space representation
% dx(5)=0;
dx(7)=v*t*cos(dx(5));
dx(7)=x(7)+dx(7);
dx(8)=v*t*sin(dx(5));
dx(8)=x(8)+dx(8);
% % % dist=(((vx*t )^2 + (vy*t)^2)^0.5);
% % % dx(7)=dist*cos(dx(5)) + x(7); %simple time integral giving displacement vx+x(7); %
% % % dx(8)=dist*sin(dx(5)) + x(8); %simple time integral giving displacement vy+x(8); %
% % % dx(9)=dx(5); %dx(5) + x(9); %adding new angle to previous one 

% keyboard

%output the state in the form which is required, i.e. x, y, and theta

out =dx;	

catch
    a=lasterror
    b=a.message
    keyboard
end

end