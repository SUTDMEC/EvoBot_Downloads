function [ thetaout ] = Conv2P2( theta )
%Conv2P2 Converts theta which wraps at pi to wrap in quadrants at pi/2
%   This is to conform to the Optitrack standard

% q = (theta < -pi/2) | (pi/2 < theta);
% theta(q) = wrapToPi(theta(q) + pi/2) - pi/2;


% positiveInput = (theta > 0);
% theta = mod(theta, pi/2);
% % theta((theta == 0) & positiveInput) = pi/2;
% theta((theta == 0) ) = pi/2;
% 
% theta(~positiveInput)=-theta(~positiveInput);

try

dtheta=abs(diff(abs(theta))); %take the absolute value of the difference in the absolute value - necessary to handle wrapping
dtheta=[0; dtheta];
dtheta(dtheta>0.1)=0; %set peaks where wrapping occurs to 0 (better assumption would be to interpolate...
thetaout(1)=theta(1);

sign=1;
for i=2:length(theta)
thetaout(i)=thetaout(i-1)+sign*dtheta(i);

if abs(thetaout(i))>pi/2 %wrap to 90 instead of 180, staying with the optitrack format
    if thetaout(i)<0
        sign=1;
    else
        sign=-1;
    end
end

% if abs(thetaout(i))>pi/2
%     keyboard
% end
end

catch
    a=lasterror
    keyboard
end


end

