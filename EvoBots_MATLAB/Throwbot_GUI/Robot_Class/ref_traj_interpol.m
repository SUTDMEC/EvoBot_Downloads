function [x_ref,y_ref,theta_ref,vel_ref,rotvel_ref,elapsed_time]=ref_traj_interpol(start_time,t,X,Y,theta,Vel,RotVel)

% This function computes the elapsed time and interpolate the input data to
% approximate the reference trajectory at current elapsed time.

elapsed_time=(now-start_time)*3600*24;

x_ref=interp1(t,X,elapsed_time,'spline');
y_ref=interp1(t,Y,elapsed_time,'spline');
theta_ref=interp1(t,theta,elapsed_time,'spline');
vel_ref=interp1(t,Vel,elapsed_time,'spline');
rotvel_ref=interp1(t,RotVel,elapsed_time,'spline');



