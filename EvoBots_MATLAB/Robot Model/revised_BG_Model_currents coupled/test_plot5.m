%plotting results
global m L J
% m=0.2;
% L=0.0015;
% l=0.14;
%J=12*m*l*l;
close

plot(t,((x(:,6)/L)));
title('Total Current');
xlabel('time (s)');
ylabel('Amperes');
pause
% plot(t,x(:,2)/L);
% title('Current2');
% xlabel('time (s)');
% ylabel('A');
% pause

plot(t,2*x(:,3)/m);
title('Velocity1');
xlabel('time (s)');
ylabel('m/s');
pause

plot(t,2*x(:,4)/m);
title('Velocity2');
xlabel('time (s)');
ylabel('m/s');
pause
% 
plot(t,(x(:,5)/J)*180/pi);
title('Angular Velocity');
xlabel('time (s)');
ylabel('Degrees/s');
pause 

% plot(x(:,6),x(:,7));
% title('Robot Trajectory');
% xlabel('x coordinate');
% ylabel('y coordinate'); 

