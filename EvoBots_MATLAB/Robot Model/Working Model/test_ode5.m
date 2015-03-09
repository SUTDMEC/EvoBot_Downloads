
function  [out1] = test_ode5(t,x)
global m L l
%target=get_target();
% theta_vect=x(:,5);
% actual=theta_vect(end);
 
%Input Parameters
% if t<5
V1=5;
V2=5;
% elseif t>=6.6&&t<=7
%     V1=5;
%     V2=3*5/4;
% else V1=5;
%     V2=5;
% end

%%%%%%%%%%%%Write algo to automate V1 and V2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=0.15;%lumped mass. More than actual mass to compensate for moment of inertia
L=0.0015;
R=0.5;
ugy=0.0052;
ut1=1/100;
ut2=0.02;
Rf=20;
l=0.15;%Length is not actual length of bot. Compensation for moment of inertia
% K=10^(1);
% J=12*m*l*l;
%The state vector = x, received after integration from the solver, at this instant.
%%p8=x(1);              %Momentum

p2=x(1);
p18=x(2);
p8=x(3);
p24=x(4);
th=x(5);
distx=x(6);
disty=x(7);
% p14=x(5);
% q11=x(6);

%w=(x(2)-x(4))/.02;

%Derivation of System Equations from the Bond graph.
%Explanation for equations given in MMES_P3_solutions_v1.docx file
%I.   What do the elements give to the system?

dp2=V1-(R*p2/L)-(2*ugy*p8/m/ut1/ut2);
dp18=V2-(R*p18/L)-(2*ugy*p24/m/ut1/ut2);
dp8=(p2*ugy/(L*ut1*ut2))-(2*Rf*p8/m);%-K*q11;
dp24=(p18*ugy/(L*ut1*ut2))-(2*Rf*p24/m);%-K*q11;
% dp14=(K*q11*l)-(Rf*p14/J);
% dq11=2*((p8-p24)/m)-l*(p14/m);
w=(2/m)*(p8-p24)/l;
vx=((2/m)*(p8+p24)*cos(th))/2;
vy=((2/m)*(p8+p24)*sin(th))/2;

dx(1)=dp2;
dx(2)=dp18;
dx(3)=dp8;
dx(4)=dp24;
dx(5)=w;
dx(6)=vx;
dx(7)=vy;

%  dx(5)=dp14;
%  dx(6)=dq11;

out1 = dx';		