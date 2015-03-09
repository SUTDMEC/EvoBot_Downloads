
clear all
clc

%Interval of Integration
tspan = [0 10];
%initial conditions, at t = 0,
%x0=[0;1];
x0 = [ 0;0;0;0;0;0;0];%...%p1(t = 0) = 0 => initial momentum = 0, mass at rest
      

%calling the solver
%options = odeset('OutputFcn', 'odeplot','OutputSel', [1 2] );

[t,x] = ode23('test_ode5', tspan, x0);
test_plot5% plot results
% 
% for i=1:(length(t))
% vx(i)=((2*x(i,3)/m)+(2*x(i,4)/m))*cos(x(i,5))/2;
% vy(i)=((2*x(i,3)/m)+(2*x(i,4)/m))*sin(x(i,5))/2;
% 
% end
% for i=1:length(t)-1
%     dy(i)=(t(i+1)-t(i))*vy(i);
%     ycoord(i)=sum(dy);
%     dx(i)=(t(i+1)-t(i))*vx(i);
%     xcoord(i)=sum(dx);
% end
% 
% plot(t,vx,'r')
% hold on
% plot(t,vy,'b')
% title('Velocities in x and y directions');
% xlabel('time (s)');
% ylabel('Velocities');
% legend('Velocity in x direction','Velocity in y direction')
% hold off
% pause
% 
% 
% % plot(t(1:length(t)-1),xcoord,'r')
% % hold on
% % plot(t(1:length(t)-1),ycoord,'b')
% % title('Distances in x-y');
% % xlabel('time (s)');
% % ylabel('Distances');
% % legend('x distance','y distance')
% 
% plot(xcoord,ycoord)
% title('Robot Trajectory');
% xlabel('x co-ordinate');
% ylabel('y co-ordinate');
%legend('Velocity in x direction','Velocity in y direction')