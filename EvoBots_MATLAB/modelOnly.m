function [xout,yout,thetaout,thetaP2]=modelOnly( ctrvec,senseTime,x0,y0,theta0,IMUData)

try
%%This function applies a simple state-transition update to predict
%%trajectory based on the model

%initialize the model function
f = @EvoBotModel_2;

%sensor time values
%T=mean(diff(senseTime))
%initialize state-vector
T=0.032;
nStates=8;

xV = zeros(nStates,length(ctrvec));%x(7,:)=xpos x(8,:)=ypos x(9,:)=theta
xV(5,1)=theta0;
xV(7,1)=x0;
xV(8,1)=y0;
%xV(9,1)=theta0;
x(1:6)=0;
x(5)=theta0;
x(7)=x0;
x(8)=y0;
%x(9)=theta0;

thetaP2=theta0;

% keyboard
%from the data, time seperation:
% dT=0.02;

x=x';

ctrvec=ctrvec';
size(ctrvec)
for i=1:length(ctrvec)-1

    x = f(x,ctrvec(:,i),T);
    xV(:,i+1) = x;
    %pause% save estimate i+1 since initial value is x0,y0,theta0
end
xV=xV';

xout=xV(:,7); %x position
yout=xV(:,8); %y position
thetaout=xV(:,5); %theta
% plot(thetaout)
% pause
% xout
% yout
% thetaout
% pause
% keyboards
% thetaP2=thetaout;
thetaP2  = Conv2P2( thetaout ); %wrap at 90deg instead of 180
thetaout=wrapToPi(thetaout);
catch
    a=lasterror
    b=a.message
    keyboard
end

end