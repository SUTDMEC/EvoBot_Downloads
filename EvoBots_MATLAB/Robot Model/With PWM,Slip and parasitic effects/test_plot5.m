%plotting results
global m L l Lp
% m=0.2;
% L=0.0015;
% l=0.14;
%J=12*m*l*l;
close

figure
plot(t,x(:,1)/L);
title('Current1');
xlabel('time (s)');
ylabel('A');


figure
plot(t,x(:,2)/L);
title('Current2');
xlabel('time (s)');
ylabel('A');

figure
plot(t,x(:,6)/Lp);
title('Parasitic Current');
xlabel('time (s)');
ylabel('A');

figure
plot(t,(x(:,1)/L+x(:,2)/L+x(:,6)/Lp));
title('Total Current');
xlabel('time (s)');
ylabel('A');

figure
plot(t,2*x(:,3)/m);
title('Velocity1');
xlabel('time (s)');
ylabel('m/s');

figure
plot(t,2*x(:,4)/m);
title('Velocity2');
xlabel('time (s)');
ylabel('m/s');

figure
plot(t,x(:,5)*180/pi/l);
title('Angle in degrees');
xlabel('time (s)');
ylabel('Degrees');

figure
plot(x(:,7),x(:,8));
title('Robot Trajectory');
xlabel('x coordinate');
ylabel('y coordinate'); 

