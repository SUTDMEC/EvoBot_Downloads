%plotting results
m=0.25;
L=0.015;


plot(t,x(:,1)/L);
title('Current');
xlabel('time (s)');
ylabel('A');
pause

plot(t,x(:,2)/m);
title('Velocity');
xlabel('time (s)');
ylabel('m/s');
pause