function  [ out1] = test_ode7(t,x)

%Input Parameters

m=0.25;                %Mass
r=0.02;              %Wheel radius in meters
ut1=1/100;             %Gear Ratio
ut2=r;                 %ut1 & ut2 is the transformer modulii             
R3=15.5;                 %Internal Resistance of Battery
R8=1;                 %Frictional loss
Se1=5;                % Voltage
ugy=0.0025;             % Gyrator Modulus (can be obtained from motor K value)
L= 0.015;             %Motor Inductance 

%The state vector = x, received after integration from the solver, at this instant.
p2=x(1);%Current
p9=x(2);%Momentum

%Derivation of System Equations from the Bond graph.
%Explanation for equations given in MMES_P3_solutions_v1.docx file
%I.   What do the elements give to the system?

e1=Se1;
f2=p2/L;
e3=R3*f2;
f9=p9/m;
e8=R8*f9;
%II.   What does the system give to the elements with integral causality?
f6=f9/ut2;
f5=f6/ut1;
e4=ugy*f5;
dp2=e1-e3-e4;         % dp8 represents the rate of change of momentum p8

e5=ugy*f2;
e6=e5/ut1;
e7=e6/ut2;
dp9=e7-e8;


%Time derivative of the state vector

dx(1) = dp2;
dx(2) = dp9;

out1 = dx';	