function  [out] = EvoBotModel_1(x,U,t)
try
%based on T. George's 'test_ode5' model, in the 'With PWM,Slip and parasitic effects' folder,
%11.July,2014

%modified by E.W.

 
%Input Parameters

V=3.8;%Battery Voltage
ratio=3.8/5;

eff_volt=5;

%%%%%%%%%%%%%%%Change this to control robot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_PWM=U(1);%Set these to values between -1 and 1
right_PWM=U(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u1=ratio/left_PWM;%Maximum is 3.8/5 min is 37
u2=ratio/right_PWM;

% u1=eff_volt*left_PWM;%Maximum is 3.8/5 min is 37
% u2=eff_volt*right_PWM;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Educated guesses%%%%%%%%%%%
m=0.15;%lumped mass. More than actual mass to compensate for moment of inertia
ut1=1/100;%Gear Ratio
ut2=0.02;% Wheel Radius
l=0.15;%Length is not actual length of bot. Compensation for moment of inertia
L=0.0015;% Inductance of motors
%%%%%%%%%%%Wild (but realistic) Guesses%%%%%%%%%%%%%%%
Rp=21;% Parasitic Resistance
R=2;% Increase causes Reduction in velocity, reduction in current
Rb=0.5;%Battery internal resistance
Rc=1;%Damping constant corresponding to coupling of the two side
ugy=0.005; %K value of motor. Decreasing this increases current and marginally increases vel
Rf=7;% Damping constant related to frictional effects. Increasing this inc the currents, reduces velocity
Lp=0.0001;%Parasitic Inductance
K12=1/100000;% Coupling stiffness

trackDistance=98; %98 mm displacement between CoM of the treads
%%%%%%%%%%%%%%%%%%%%%%


%The state vector = x, received after integration from the solver, at this instant.

p2=x(1);
p20=x(2);
p8=x(3);
p14=x(4);
q12=x(5);
p28=x(6);
distx=x(7);
disty=x(8);

%w=(x(2)-x(4))/.02;

%I.   What do the elements give to the system?

dp2=V/u1-(Rb/u1)*(p2/L/u1+p20/L/u2+p28/Lp)-(R*p2/L)-(2*ugy*p8/m/ut1/ut2);
dp20=V/u2-(Rb/u2)*(p2/L/u1+p20/L/u2+p28/Lp)-(R*p20/L)-(2*ugy*p14/m/ut1/ut2);
dp8=(p2*ugy/(L*ut1*ut2))-Rf*(2*p8/m)-K12*q12-Rc*((2*p8/m)-2*p14/m);%-K*q11;
dp14=(p20*ugy/(L*ut1*ut2))-Rf*(2*p14/m)-K12*q12-Rc*((2*p8/m)-2*p14/m);
dq12=((2*p8/m)-2*p14/m);
dp28=V-Rb*(p2/L/u1+p20/L/u2+p28/Lp)-Rp*(p28/Lp);
vx=((2/m)*(p8+p14)*cos(q12/l))/2;
vy=((2/m)*(p8+p14)*sin(q12/l))/2;

% dq11=2*((p8-p24)/m)-l*(p14/m);

dx(1)=dp2;
dx(2)=dp20;
dx(3)=dp8;
dx(4)=dp14;
dx(5)=dq12;
dx(6)=dp28;
dx(7)=vx;
dx(8)=vy;

x(1:8)=0;


dist=((vx*t )^2 + (vy*t)^2)^0.5;
dx(9)=dist*cos(dx(5)/l) + x(9); %simple time integral giving displacement
dx(10)=dist*sin(dx(5)/l) + x(10); %simple time integral giving displacement
dx(11)=dx(5)/l + x(11); %adding new angle to previous one 

% keyboard

%output the state in the form which is required, i.e. x, y, and theta

out = dx';	

catch
    a=lasterror
    b=a.message
    keyboard
end

end