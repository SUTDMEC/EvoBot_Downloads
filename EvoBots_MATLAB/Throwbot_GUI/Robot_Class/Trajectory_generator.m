function [t,X,Y,theta,Vel,RotVel]=Trajectory_generator(Trajectory)


pos_vec = Trajectory./100;% change from cm to m
%     pos_vec=pos_vec-ones(length(pos_vec),1)*pos_vec(1,:)+ones(length(pos_vec),1)*pos(1:2);

Traj_length = sum((diff(pos_vec(:,1)).^2+diff(pos_vec(:,2)).^2).^0.5);%length of the trajectory
arbit_sim_dutation = Traj_length/0.1;%the time robot is supposed to follow the trajectory
% arbit_sim_dutation=20;
t = linspace(0,arbit_sim_dutation,length(pos_vec));
smooth_path = smoothn({pos_vec(:,1),pos_vec(:,2)},100,'robust');
X = smooth_path{1};
Y = smooth_path{2};
Xdot = diffxy(t,X);
Ydot = diffxy(t,Y);
Vel = (Xdot.^2+Ydot.^2).^0.5;
X2dot = diffxy(t,Xdot);
Y2dot = diffxy(t,Ydot);
RotVel = (Y2dot.* Xdot-X2dot.*Ydot)./(Vel.^2);
theta = atan2(Ydot,Xdot);
theta = unwrap(theta);