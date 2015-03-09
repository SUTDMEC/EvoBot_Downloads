
function  [out1] = July_18_test_ode5(t,x)
global m L l Lp


V=5;%Stepped up Battery Voltage
%Change u1 and u2 to change the voltages to the motors. The third input is
%V and is kept constant. This constant input voltage is assumed to act directly on
%the parasitic components Lp and Rp
u1=1;
u2=1;
V1=u1*V;%PWM voltages to left and right motors
V2=u2*V;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Educated guesses%%%%%%%%%%%
m=0.15;%lumped mass. More than actual mass to compensate for moment of inertia
ut1=1/100;%Gear Ratio
ut2=0.02;% Wheel Radius
l=0.2;%Length is not actual length of bot. Compensation for moment of inertia
L=0.0015;% Inductance of motors
%%%%%%%%%%%Wild (but realistic) Guesses%%%%%%%%%%%%%%%
Rp=21;% Parasitic Resistance
R=2;% Increase causes Reduction in velocity, reduction in current
%Rc=1;%Damping constant corresponding to coupling of the two side
ugy=0.005; %K value of motor. Decreasing this increases current and marginally increases vel
Rf=21;% Damping constant related to frictional effects. Increasing this inc the currents, reduces velocity
Lp=0.0001;%Parasitic Inductance
%%%%%%%%%%%%%%%%%%%%%%

%The state vector = x, received after integration from the solver, at this instant.

p2=x(1);
p20=x(2);
p8=x(3);
p14=x(4);
p28=x(5);

distx=x(6);
disty=x(7);
th=x(8);

%I.   What do the elements give to the system?

dp2=V1-(R*p2/L)-(2*ugy*p8/m/ut1/ut2);
dp20=V2-(R*p20/L)-(2*ugy*p14/m/ut1/ut2);
dp8=(p2*ugy/(L*ut1*ut2))-(2*Rf*p8/m);%-K*q11;
dp14=(p20*ugy/(L*ut1*ut2))-(2*Rf*p14/m);%-K*q11;
dp28=V-Rp*p28/Lp;
w=(2/m)*(p8-p14)/l;
vx=((2/m)*(p8+p14)*cos(th))/2;
vy=((2/m)*(p8+p14)*sin(th))/2;



dx(1)=dp2;
dx(2)=dp20;
dx(3)=dp8;
dx(4)=dp14;
dx(5)=dp28;
dx(6)=vx;
dx(7)=vy;
dx(8)=w;
out1 = dx';		