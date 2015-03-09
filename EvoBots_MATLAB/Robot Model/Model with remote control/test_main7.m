
%Model with m,J,k,L
%Sample solution to P3

clear all
clc
%Interval of Integration
tspan = [0 10];
%initial conditions, at t = 0,
%x0=[0;1];
x0 = [0;0];%...%p1(t = 0) = 0 => initial momentum = 0, mass at rest, initial electrical momentum=0;
      

%calling the solver
%options = odeset('OutputFcn', 'odeplot','OutputSel', [1 2] );

[t,x] = ode45('test_ode7', tspan, x0);
test_plot7% plot results

vel=x(:,2)/m;
for i=2:length(t)
   delt(i)=t(i)-t(i-1);
   delv(i)=vel(i)-vel(i-1);
   acc(i)=delv(i)/delt(i);
end

plot(t(1:length(t)),acc)
%plot(t(2:length(t)),diff(x(:,4))/m/delt(2:end))
title('Acceleration');
xlabel('time (s)');
ylabel('m/s^2');