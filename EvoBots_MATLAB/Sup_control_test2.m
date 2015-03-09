%% This script tests the STARS supervisory controller script

close all;
clear all;
startup_rvc
addpath('C:\Users\Erik Wilhelm\Documents\MATLAB\SUTD_code\robot-9.8\rvctools\')

load erikmap;

try
f = figure;
h = uicontrol('Position',[20 20 200 40],'String','Push "q" to continue the script',...
              'Callback','uiresume(gcbf)');
uiwait(gcf); 
close(f);

randomness_factor=2; %the lower the less random
map = makemap(map);

%initialize starting positions

vehs(:,:,1)=[20,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,2)=[40,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,3)=[60,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,4)=[80,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,5)=[100,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,6)=[120,40,pi()/2+(-2*randn-1)/randomness_factor];
vehs(:,:,7)=[140,40,pi()/2+(-2*randn-1)/randomness_factor];

%test theta control strategy
ts=size(vehs);
steps = 15;
Kp=0.3;

distance=5;
look_ahead=15; %distance sensed ahead for obstacles

for k=2:steps
    meantheta=mean(vehs(k-1,3,:));
    
    for j=1:ts(3) %update positions using a simple proportional feedback controller
        vehs(k,:,j)=[vehs(k-1,1,j)+distance*cos(vehs(k-1,3,j)),vehs(k-1,2,j)+distance*sin(vehs(k-1,3,j)),vehs(k-1,3,j)+Kp*(meantheta-vehs(k-1,3,j)) ];
        if map(floor(vehs(k,1,j)+look_ahead*cos(vehs(k,3,j))),floor(vehs(k,2,j)+look_ahead*sin(vehs(k,3,j))))==1 %position ahead is equal to one indicating an obstacle
            vehs(k,3,j)=vehs(k,3,j)-pi()/2; %turn 90 deg
        end
    end
end

%plot results

ts=size(vehs);

for i=1:ts(1) %loop through the convergance iterations
for j=1:ts(3) %loop through the vehicles
    plot_vehicle(vehs(i,:,j))
end
pause(0.5)
end

catch err
    a=err.message
    b=err.stack
end