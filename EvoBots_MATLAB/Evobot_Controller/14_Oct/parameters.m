R=.4;% Circle Radius
cycles=2;%the number of cycles the robot should have
run_time=100;%the running time
l=.11;%model prameter
K1=5;%controller gain
K2=15;%controller gain
K3=5;%controller gain
Ts=200e-3;
PWM=1;

%% Ploting the results
plot(Outputs.Data(:,1),Outputs.Data(:,2),'LineWidth',3);
hold on;
grid on;
plot(Reference.Data(:,1),Reference.Data(:,2),'-.r','LineWidth',3);
xlabel('x');
ylabel('y');
legend('Current Posture','Reference Posture');
figure;
plot(Error.Time,Error.Data(:,1),'LineWidth',3);
hold on;
grid on;
plot(Error.Time,Error.Data(:,2),'-.r','LineWidth',3);
plot(Error.Time,Error.Data(:,3),':m','LineWidth',3);
xlabel('Time');
legend('Error in x','Error in y','Errrot in \theta')
figure;
plot(Control_Input.Time,Control_Input.Data(:,1),'LineWidth',3);
grid on;
hold on;
plot(Control_Input.Time,Control_Input.Data(:,2),'-.r','LineWidth',3);
legend('Velocity input to the right motor','Velocity input to the left motor')
xlabel('Time');
ylabel('Velocity (m/s)');

