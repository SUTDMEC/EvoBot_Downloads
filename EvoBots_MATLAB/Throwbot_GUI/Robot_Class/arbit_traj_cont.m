function [v1,v2]=arbit_traj_cont(x,xr,yr,theta_r,vr,wr)

l=0.11;
kx=4;
ky=9;
k_theta=3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xc=x(1);
yc=x(2);
theta_c=x(3);
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
% if (error_x^2+error_y^2)^.5>0.06
%     v1;
%     v2;
% end
if abs(v1)>150
    v1=sign(v1)*150;
end

if abs(v2)>150
    v2=sign(v2)*150;
end