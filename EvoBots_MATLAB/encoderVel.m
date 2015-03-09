function [v1,v2,etheta,ethetaP2]=encoderVel(encoderData,theta0,dT )

%based on mm displacement from the encoder, calculate displacement and
%angle

try

trackDistance=98; %98 mm displacement between CoM of the treads

%get common mode local translation component
dl=diff(encoderData.Left);
dl=[0; dl];
dr=diff(encoderData.Right);
dr=[0; dr];

v1=(dl./1000)./dT; %velocity of left track
v2=(dr./1000)./dT; %velocity of right track

v1(v1<-4 | v1>4)=0; %eliminate physically implausible features
v2(v2<-4 | v2>4)=0; %eliminate physically implausible features

%get differential mode rotation component, differential mode dx = 0 always due to sensor physical placement
dangle=(dr-dl)./trackDistance;

%create sum vector for all of the outputs
etheta=zeros(length(encoderData.Left),1);
ethetaP2=zeros(length(encoderData.Left),1);

etheta(1)=theta0;
ethetaP2(1)=theta0;

sign=1;

for i=1:length(encoderData.Left)-1
    
    etheta(i+1)=dangle(i)/2+etheta(i);
    ethetaP2(i+1)=sign*dangle(i)/2+ethetaP2(i);
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
