function [ex,ey,etheta,ethetaP2]=encoderFlow(encoderData,xo,yo,theta0)

%based on mm displacement from the encoder, calculate displacement and
%angle

try

trackDistance=98; %98 mm displacement between CoM of the treads

%get common mode local translation component
dl=diff(encoderData.Left);
dl=[0; dl];
dr=diff(encoderData.Right);
dr=[0; dr];

%get differential mode rotation component, differential mode dx = 0 always due to sensor physical placement
dangle=(dr-dl)./trackDistance;

%create sum vector for all of the outputs
etheta=zeros(length(dangle),1);
ex=zeros(length(dangle),1);
ey=zeros(length(dangle),1);

etheta(1)=theta0;
ethetaP2(1)=theta0;
ex(1)=xo;
ey(1)=yo;
sign=1;

for i=1:length(dangle)
    
    etheta(i+1)=dangle(i)/2+etheta(i);
    ethetaP2(i+1)=sign*dangle(i)/2+ethetaP2(i);
    ex(i+1)=dl(i)*cos(etheta(i+1))-dr(i)*sin(etheta(i+1))+ex(i);
    ey(i+1)=dl(i)*sin(etheta(i+1))+dr(i)*cos(etheta(i+1))+ey(i);
    etheta(i+1)=dangle(i)/2+etheta(i+1);
    ethetaP2(i+1)=sign*dangle(i)/2+ethetaP2(i+1);
%     ethetaP2(i+1)=ethetaP2(i+1)*sign;
    etheta(i+1) = wrapToPi(etheta(i+1));
%     test=ethetaP2(i+1)
%     keyboard
    if abs(ethetaP2(i+1))>pi/2
        if ethetaP2(i+1)<0
            sign=-1;
        else
            sign=1;
        end
    end
end

% keyboard
catch
    a=lasterror
    keyboard
end


% keyboard
