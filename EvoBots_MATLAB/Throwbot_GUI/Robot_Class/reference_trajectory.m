function [ref_traj]=reference_trajectory(t)
R=1;
wr=0.1;
ref_traj(1)=R*cos(wr*t);%0.4;
ref_traj(2)=R*sin(wr*t);%0.4;
ref_traj(3)=wr*t+pi/2;
ref_traj(4)=wr*R;%0.2;
ref_traj(5)=wr;