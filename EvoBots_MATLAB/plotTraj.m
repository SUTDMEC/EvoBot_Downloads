function plotTraj(in)

%This function plots the 'demo quality' SLAM step-wise as a demonstration
% it depends on having the robotics toolkit 9.8 installed: http://petercorke.com/Robotics_Toolbox.html

%in.x = vector of x states
%in.y = vector of y states
%in.theta = vector of headings

try
    
addpath('C:\Users\Erik Wilhelm\Documents\MATLAB\SUTD_code\mpgwrite_6.0_update');
% Real data
traj=[in.x in.y];
pose=in.theta;

% Random testing trajectory and pose 
% n=20;
% traj=[rand(n,1) rand(n,1)];
% pose=zeros(n,1);

writerObj = VideoWriter(in.moviefile);
open(writerObj);
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');

hold
grid on
%Adjust to fit to arena size
xlim([min(traj(:,1))-0.5 max(traj(:,1))+0.5])
ylim([min(traj(:,2))-0.5 max(traj(:,2))+0.5])
r=3;

for i=1:in.skip_val:length(traj)-1 %uncomment for test data
%     pose(i)=atan(traj(i+1,2)-traj(i,2))/(traj(i+1,1)-traj(i,1))-pi;
    
    
%     %uncomment for test data
% for i=1:length(pose) % real data
    plot2([traj(1:i,1),traj(1:i,2)]) %plots the lines for the trajectories
    
    if rem(i,500)==1 && i>1 %for every 100 10 point, plot the trajectory
        
        plot(traj(i,1),traj(i,2),'ro','MarkerSize',6,'MarkerFaceColor','r')
%         sthet = mean(pose(i-499:i)); %can also use pose
%         keyboard
%         u= r*cos(sthet*pi/180 + pi/2);
%         v=r*sin(sthet*pi/180+ pi/2);
%         keyboard
%         plot_vehicle([traj(i,1),traj(i,2),pose(i)],'size',1); %plots the vehicle
%         squiver(traj(i,1),traj(i,2),u,v,'color','red','linewidth',2)
    end
    frame = getframe;
    writeVideo(writerObj,frame);
    pause(0.05);
end

close(writerObj);

catch
    a=lasterror
    keyboard
end