%plotting results
global m L l Lp
% m=0.2;
% L=0.0015;
% l=0.14;
%J=12*m*l*l;
close

plot(t,x(:,1)/L);
title('Current1');
xlabel('time (s)');
ylabel('A');
pause


plot(t,x(:,2)/L);
title('Current2');
xlabel('time (s)');
ylabel('A');
pause

% plot(t,x(:,6)/Lp);
% title('Parasitic Current');
% xlabel('time (s)');
% ylabel('A');
% pause 

plot(t,(abs(x(:,1))/L+abs(x(:,2))/L)+abs(x(:,5))/Lp);
title('Total Current');
xlabel('time (s)');
ylabel('A');
pause

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
plot(t,x(:,8)*180/pi);
title('Angle in degrees');
xlabel('time (s)');
ylabel('Degrees');

pause
% plot(x(:,7),x(:,8));
% title('Robot Trajectory');
% xlabel('x coordinate');
% ylabel('y coordinate'); 
% % 
plot(x(:,6),x(:,7));
title('Robot Trajectory');
xlabel('x coordinate');
ylabel('y coordinate'); 

