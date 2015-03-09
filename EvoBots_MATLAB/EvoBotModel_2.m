function  [out] = EvoBotModel_2(x,U,t)
try
format long
%based on T. George's 'test_ode5' model
U=U/100;%scale down the inputs to the range -1 to 1
%modified by E.W.

%%  Based on this model formulation, the below discrete model was generated
%Input Parameters
% 
V=5;%Battery Voltage

% %%%%%%%%%%%Educated guesses%%%%%%%%%%%
m=0.15;%lumped mass. More than actual mass to compensate for moment of inertia
G=1/100;%Gear Ratio
r=0.02;% Wheel Radius
l=0.095;%Length is not actual length of bot. Compensation for moment of inertia
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
A=[-R/L ,  0 , -K/(G*r*L) , 0 , 0 , 0;
   0 ,   -R/L ,  0  , -K/(G*r*L) ,  0 ,  0;
   2*K/(G*r*L) ,   0 ,  (-2*Rf)/m , 0  , 0 ,  0;
   0  ,  2*K/(G*r*m)  , 0 ,  (-2*Rf)/m ,  0  , 0;
   0  ,  0  , 1/l ,  -1/l ,  0 ,  0;
   0  ,  0  , 0 ,  0 ,  0  , -Rp/Lp;];
B=[ V/L,0,0;
    0,V/L,0;
    0,0,0;
    0,0,0;
    0,0,0;
    0,0,V/Lp;];

C=[0,0,0,0,0,0];

D=[0,0,0];

sys = ss(A,B,C,D);
sysd= c2d(sys,t); 

%The state vector = x, received after integration from the solver, at this instant.

%% This model results after discrtization of Thommen's robot model
A=sysd.a;
B=sysd.b;

if ~iscolumn(x) %retranspose for initial conditions sizing error
    x=x';
end


dx=A*x(1:6)+B*[U(2);U(1);1];
v=((dx(3)+dx(4)))/2;%average velocity
dx(7)=v*t*cos(dx(5));%x velocity
dx(7)=x(7)+dx(7);%integration to get x distance
dx(8)=v*t*sin(dx(5));%y velocity
dx(8)=x(8)+dx(8);%integration to get y distance


out =dx;	

catch
    a=lasterror
    b=a.message
    keyboard
end

end