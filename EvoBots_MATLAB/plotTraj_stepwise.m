function plotTraj_stepwise(in)

%This function plots the 'demo quality' SLAM step-wise as a demonstration
% it depends on having the robotics toolkit 9.8 installed: http://petercorke.com/Robotics_Toolbox.html

%in.x = vector of x states
%in.y = vector of y states
%in.theta = vector of headings

try
    
addpath('C:\Users\Erik Wilhelm\Documents\MATLAB\SUTD_code\mpgwrite_6.0_update');

figure
writerObj = VideoWriter(in.moviefile);
open(writerObj);
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');

hold
grid on
xlabel('x Position (cm)')
ylabel('y Position (cm)')

%Adjust to fit to arena size
xlim([-100 100])
ylim([-100 100])


for i=1:length(in.map_out) %uncomment for test data
    
    xs=[in.state{i}.x(1);in.state{i}.x(end)];
    ys=[in.state{i}.y(1);in.state{i}.y(end)];
    plot2([xs,ys]) %plots the lines for the trajectories
    plot(xs(end),ys(end),'ro','MarkerSize',6,'MarkerFaceColor','r')
    x_wall=in.map_out{i}.landmark_x_location';
    y_wall=in.map_out{i}.landmark_y_location';
    plot(x_wall,y_wall,'k*')
    frame = getframe;
    writeVideo(writerObj,frame);
    legend({'Path' 'Step' 'Walls'},'Location','SouthWest')
    pause(0.1);
end

% %plot ground truth
% scaledGTx=-in.GTx*100;
% scaledGTy=in.GTy*100;
% x_offset=in.BOTx(1)-scaledGTx(1);
% y_offset=in.BOTy(1)-scaledGTy(1);
% 
% plot(scaledGTx+x_offset,scaledGTy+y_offset,'r')
% 
% frame = getframe;
% writeVideo(writerObj,frame);

close(writerObj);

catch
    a=lasterror
    keyboard
end