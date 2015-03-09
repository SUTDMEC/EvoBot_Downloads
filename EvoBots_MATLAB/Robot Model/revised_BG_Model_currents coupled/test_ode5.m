
function  [out1] = test_ode5(t,x)
global m L J
%target=get_target();
% theta_vect=x(:,5);
% actual=theta_vect(end);
 
%Input Parameters
% if t<5
V1=5;
V2=5/4;
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
J=12*m*l*l;
K=1;
%The state vector = x, received after integration from the solver, at this instant.
%%p8=x(1);              %Momentum

p20=x(1);
p24=x(2);
p7=x(3);
p15=x(4);
p13=x(5);
q=x(6);

% p14=x(5);
% q11=x(6);

%w=(x(2)-x(4))/.02;

%Derivation of System Equations from the Bond graph.
%Explanation for equations given in MMES_P3_solutions_v1.docx file
%I.   What do the elements give to the system?

dp20=V1-K*q-(2*ugy*p7/m/ut1/ut2)-R*2*p20/m;
dp24=V2-K*q-(2*ugy*p7/m/ut1/ut2)-R*2*p24/m;

dp7=(p20*ugy/(L*ut1*ut2))-Rf*((2*p7/m)-(2*p15/m)-l*p13/J);%-K*q11;
dp15=(p24*ugy/(L*ut1*ut2))-Rf*((2*p7/m)-(2*p15/m)-l*p13/J);
dp13=l*Rf*((2*p7/m)-(2*p15/m)-l*p13/J)-l*p13/J;%-K*q11;
% dp14=(K*q11*l)-(Rf*p14/J);
% dq11=2*((p8-p24)/m)-l*(p14/m);
dq=p20/L+p24/L;

dx(1)=dp20;
dx(2)=dp24;
dx(3)=dp7;
dx(4)=dp15;
dx(5)=dp13;
dx(6)=dq;

%  dx(5)=dp14;
%  dx(6)=dq11;

out1 = dx';		