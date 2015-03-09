function [mx,my,mtheta]=opticalFlow(opticalData,xo,yo,theta0)

%based on mm displacement from the sensors, calculate optical flow
%displacement

%note, always assumes a start at 0,0, with 0rad rotation

%Note, in a next step, should treat each measurement independently in the
%motion model

flowSensorDistance=30; %mm displacement between sensors (does wen use 30?)

%get common mode local translation component
ave_dx=(opticalData.L_x+opticalData.R_x)./2;
ave_dy=(opticalData.L_y+opticalData.R_y)./2;

%get differential mode rotation component, differential mode dx = 0 always due to sensor physical placement
dangle=(opticalData.R_y-opticalData.L_y)./flowSensorDistance;

%create sum vector for all of the outputs
mtheta=zeros(length(dangle),1);
mx=zeros(length(dangle),1);
my=zeros(length(dangle),1);

mtheta(1)=theta0;
mx(1)=xo;
my(1)=yo;

for i=2:length(dangle)
    mtheta(i)=dangle(i)/2+mtheta(i-1);
    mx(i)=ave_dx(i)*cos(mtheta(i))-ave_dy(i)*sin(mtheta(i))+mx(i-1);
    my(i)=ave_dx(i)*sin(mtheta(i))+ave_dy(i)*cos(mtheta(i))+my(i-1);
    mtheta(i)=dangle(i)/2+mtheta(i);
    mtheta(i) = wrapToPi(mtheta(i));
end

% keyboard
