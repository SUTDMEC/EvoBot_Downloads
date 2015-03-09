%This model decouples the two motors from each other as well as from the
%parasitic effects. The model uses three inputs, represented by u1, u2 and
%1. u1 and u2 (corresponding voltages are u1*V and u2*V) are changed to change the input voltages to the two motors
%and 1 (corresponding voltage is 1*V=V) is an input which acts directly on the parasitic effects
clear all
clc
tic
%Interval of Integration
tspan = [0 1];
%initial conditions, at t = 0,
%x0=[0;1];
x0 = [ 0;0;0;0;0;0;0;0];%...%p1(t = 0) = 0 => initial momentum = 0, mass at rest
      

%calling the solver
%options = odeset('OutputFcn', 'odeplot','OutputSel', [1 2] );

[t,x] = ode23s('July_18_test_ode5', tspan, x0);
toc
July_18_test_plot5% plot results
