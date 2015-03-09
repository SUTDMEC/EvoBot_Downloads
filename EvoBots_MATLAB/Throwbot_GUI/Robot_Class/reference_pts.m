function [xy_pt,len]=reference_pts(counter)

XY=[0.2,0.5;0.7,0.5;0.7,0;0.2,0];
xy_pt=XY(counter,:);
len=length(XY);