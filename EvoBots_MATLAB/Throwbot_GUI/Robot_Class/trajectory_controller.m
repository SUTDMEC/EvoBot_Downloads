function [v1,v2,error_x,error_y,ref_traj]=trajectory_controller(x,start_time)

l=0.11;
kx=4;
ky=9;
k_theta=3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xc=x(1);
yc=x(2);
theta_c=x(3);
t=(now-start_time)*3600*24;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ref_traj]=reference_trajectory(t);

xr=ref_traj(1);
yr=ref_traj(2);
theta_r=ref_traj(3);
% theta_r=atan((yr-yc)/xr-xc);
vr=ref_traj(4);
wr=ref_traj(5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xe=(cos(theta_c))*(xr-xc)+(sin(theta_c))*(yr-yc);
ye=(-sin(theta_c))*(xr-xc)+(cos(theta_c))*(yr-yc);
theta_e=theta_r-theta_c;

error_x=xr-xc;
error_y=yr-yc;
% v1=536*(vr*cos(theta_e)+kx*xe+(l/2)*(wr+vr*(ky*ye+k_theta*sin(theta_e))));
% v2=536*(vr*cos(theta_e)+kx*xe-(l/2)*(wr+vr*(ky*ye+k_theta*sin(theta_e))));
v1=1000*(vr*cos(theta_e)+kx*xe+(l/2)*(wr+vr*(ky*ye+k_theta*sin(theta_e))));
v2=1000*(vr*cos(theta_e)+kx*xe-(l/2)*(wr+vr*(ky*ye+k_theta*sin(theta_e))));
if abs(v1)>150
    v1=sign(v1)*150;
end

if abs(v2)>150
    v2=sign(v2)*150;
end