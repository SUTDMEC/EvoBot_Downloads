
%Run this file to simulate Evobot Gen1. 
%This Model simulates the robot's PWM, Parasitic effects (power consumed by IR, optical flow etc also accounted for), Slippage between the wheels while turning and the robot's motion and dynamics in 2D  
close all
clear all
clc
tic
%Interval of Integration
tspan = [0 10];
%initial conditions, at t = 0,
%x0=[0;1];
x0 = [ 0;0;0;0;0;0;0;0];%...%p1(t = 0) = 0 => initial momentum = 0, mass at rest


%% Build control input vector for each test
root_dir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\11_July_Tests\11_July_Tests';

%NOTE: THIS SECTION SHOUDL BE AUTOMATED IN THE FUTURE BASED ON COMMANDS
%PARSED FROM THE SENSOR DATA FILE. For the time being, the commands in the
%sensor data file were partially removed
if ~exist('ctr','var')
    control=importdata(strcat(root_dir,'\TestPowerToControlMapping.xlsx'));
    ctr=struct2cell(control.data);

    field_ind=1;

    for i=1:k
        for j=1:m
            ct_vec{i}{j}=zeros(length(data{i}{j}.Time),2); %initialize the control vector
            [sdr ~]=size(ctr{field_ind});
            v_ind=2;
            for s=1:length(data{i}{j}.Time) %cycle through process the data into a control vector to the length of the data file
                if v_ind<=sdr %allows to run out the last value
                    if s>ctr{field_ind}(v_ind,1) %cycle the indicies
                        v_ind=v_ind+1;
                    end
                end
                ct_vec{i}{j}(s,1)=ctr{field_ind}(v_ind-1,2); %left motor control
                ct_vec{i}{j}(s,2)=ctr{field_ind}(v_ind-1,3); %right motor control
            end
    %         keyboard
           field_ind=field_ind+1;
        end
    end

end

u=ct_vec;
%%

%calling the solver
%options = odeset('OutputFcn', 'odeplot','OutputSel', [1 2] );

[t,x] = ode23s(@(t,x) test_ode5(t,x,u), tspan, x0);
keyboard
toc
test_plot5% plot results
