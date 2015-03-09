
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
x0 = [ 0;0;0;0;0;0;0;0;0;0;0];%...%p1(t = 0) = 0 => initial momentum = 0, mass at rest
      

%calling the solver
%options = odeset('OutputFcn', 'odeplot','OutputSel', [1 2] );

[t,x] = ode23s('test_ode5', tspan, x0);
%keyboard
toc
test_plot5% plot results
