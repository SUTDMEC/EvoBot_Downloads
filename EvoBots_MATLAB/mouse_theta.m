function  out = mouse_theta( in )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
mousel_data = [in.synch_data.left_mouse_sync.data]; %make a matrix of delt_x and delta_y movements of mouse 1
mouser_data = [in.synch_data.right_mouse_sync.data];% make a matrix of delta_x and delta_y movements of mouse2
%indeg_currentangle=theta+90;
currentl_pos = in.previous_l_position(1,:);%get current position of (-13,0). First row of matrix
currentr_pos = in.previous_r_position(1,:);%same as above for right mouse
imu_heading=in.synch_data.sen_sync_left.data;
% if(currentr_pos(1)-currentl_pos(1) == 0) %if x2-x1 = 0 just return that the angle is 0
%     indeg_currentangle = 0;
% else
angle = atan2d((currentr_pos(2) - currentl_pos(2)),(currentr_pos(1)-currentl_pos(1)));%calculating the slope
%     angle=(angle*180/pi);
%      if (angle<0)
%          angle=angle+180;
%      end
indeg_currentangle = (angle)+90;%taninv(slope) gives slope angle. This angle + 90  gives robot orientation
% indeg_currentangle=(imu_heading(1,12));
prevl_position = currentl_pos;% store the current position as prev for next calculation
prevr_position = currentr_pos;%same as above
%end
% keyboard
for i=1:(min(length(mouser_data),length(mousel_data))) %this for loop will have to changed appropriately based on how the data is read.(if using intersect sync, time vectors may vary - choose minimum time)
    %     keyboard
    currentl = [mousel_data(i,:)];%read a new row which has (delta_x,delta_y) values and make it a matrix
    currentr = [mouser_data(i,:)];
    %The line below calculates the new position based on previous
    %coords,previous angle subtended and current (x,y) movements- for left
    %mouse
    currentl_pos = [(prevl_position(1) + (currentl(1)*sind(indeg_currentangle)) +(currentl(2)*cosd(indeg_currentangle))) (prevl_position(2) + (currentl(2)*sind(indeg_currentangle)) + (currentl(1)*cosd(indeg_currentangle)))];
    %Same as above but for right mouse
    currentr_pos = [(prevr_position(1) + (currentr(1)*sind(indeg_currentangle)) +(currentr(2)*cosd(indeg_currentangle))) (prevr_position(2) + (currentr(2)*sind(indeg_currentangle)) + (currentr(1)*cosd(indeg_currentangle)))];
    %     if(currentr_pos(1)-currentl_pos(1) == 0)
    %         indeg_currentangle = 0;
    %     else
    angle = atan2d((currentr_pos(2) - currentl_pos(2)),(currentr_pos(1)-currentl_pos(1)));%Finding slope
    %         angle=(angle*180/pi);
    %       if (angle<-80 && indeg_currentangle > 170 )
    %          angle=angle+180;
    %      end
    indeg_currentangle = ( angle)+90; %converting to deg
    
%     if ((floor(i/5)+1)>length(imu_heading(:,1)))
%     error_theta(i)=imu_heading(length(imu_heading(:,1)-1),12)-indeg_currentangle;
%    
%     indeg_currentangle=(imu_heading(length(imu_heading(:,1)-1),12));
%     else
%     error_theta(i)=imu_heading(floor(i/5)+1,12)-indeg_currentangle;
%     
%     indeg_currentangle=(imu_heading(floor(i/5)+1,12));
%     end
    
    prevl_position = currentl_pos; %remember new position
    prevr_position = currentr_pos;%remember new posotion
%end
%     scatter(currentl_pos(1),currentl_pos(2)); %plotting just for test purpose
%     scatter(currentr_pos(1),currentr_pos(2));
%     hold on;
%     %axis([-3 10 -3 10]);

robot_x_poisition(i)=(currentl_pos(1)+currentr_pos(1))/2;
robot_y_poisition(i)=(currentl_pos(2)+currentr_pos(2))/2;
robot_theta(i)=indeg_currentangle;

l_mouse_movement(i,:)=currentl_pos;   % for plotting the data of the left mouse
r_mouse_movement(i,:)=currentr_pos;     % for plotting the data of the right mouse
%     pause(0.008);

end
out.previous_mice_time=in.synch_data.right_mouse_sync.time;
out.mice_x =robot_x_poisition;
out.mice_y = robot_y_poisition;
out.mice_theta = robot_theta;

out.previous_l_position= currentl_pos;
out.previous_r_position=currentr_pos;
out.heading_difference=robot_theta;
% to be removed later only for debugging, plotting the mouse data
out.l_mouse_movement=l_mouse_movement;
out.r_mouse_movement=r_mouse_movement;

end


