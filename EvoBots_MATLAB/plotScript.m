addpath('C:\Users\Erik Wilhelm\Documents\MATLAB\SUTD_code\robot-9.8');


x=0;
y=0;
theta=90;
landmark_x=[];
landmark_y=[];

for i=1:length(in.map_out)
    
    x=[x;in.state{i}.x(end)];
    y=[y;in.state{i}.y(end)];
    theta=[theta;in.state{i}.theta(end)];
    landmark_x=[landmark_x; in.map_out{i}.landmark_x_location'];
    landmark_y=[landmark_y; in.map_out{i}.landmark_y_location'];
end

in.x=x;
in.y=y;
in.theta=theta;

plotTraj(in);

plot(landmark_x,landmark_y,'*k')
xlim([min(landmark_x)-5 max(landmark_x)+5])
ylim([min(landmark_y)-5 max(landmark_y)+5])