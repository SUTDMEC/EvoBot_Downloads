%% Initialise parameters

R=.4;% Circle Radius
cycles=2;%the number of cycles the robot should have
run_time=50;%the running time
l=.2;%model prameter
K1=5;%controller gain
K2=10;%controller gain
K3=5;%controller gain
Ts=300e-3;
PWM=.18;
%% Simulate the model
sim('controller');
save('U1','U1');
save('U2','U2');
%% start communication
s=Bluetooth('Evobot_211',1)
fopen(s)
fprintf(s,'&');
load U1
load U2
u=[U1.Data U2.Data];
u=(u)*100;
%fopen(s);
fid=fopen('test2data3.csv','w');
for i=1:length(u)
    
    fprintf(s,'%s',strcat('w',num2str(round(u(i,1))),';',num2str(round(u(i,2))),';','300;'))
    str=fscanf(s);
    T=0;
    while (T<30)
    
        fprintf(fid,fscanf(s));
        T=T+20;
        j=j+1;
    end
    pause(Ts)
end
%fclose(s)
