function  out = optical_theta( in )
try
    %   this function is for the calculation of the theta and the position
    %   of the robot
    
    % this loop uses the optical sensor data from each robot and makes it
    % in the redeable format
    for m= 1:(length(in.data(in.n,:))-1)
%         left_x(m)= in.data{in.n,m}.sens_data(10);
%         left_y(m)= in.data{in.n,m}.sens_data(11);
%         right_x(m)= in.data{in.n,m}.sens_data(12);
%         right_y(m)= in.data{in.n,m}.sens_data(13);
%         Robot_Yaw(m)= in.data{in.n,m}.sens_data(9);
        
% MARK ADDED THIS IF STATEMENT (on lines where it says "stopped", there is
% no data and it crashes)
        if in.data{in.n,m}.interrupt == 0   %if there is an interrupt, theres no data
            left_x(m)= in.data{in.n,m}.sens_data(12);
            left_y(m)= in.data{in.n,m}.sens_data(13);
            right_x(m)=in.data{in.n,m}.sens_data(12);
            right_y(m)= in.data{in.n,m}.sens_data(3);
            Robot_Yaw(m)= in.data{in.n,m}.sens_data(9);

            encoder_y(m) = in.data{in.n,m}.sens_data(13);
        end

    end
    opticall_data = [left_x'  left_y']; %make a matrix of delt_x and delta_y movements of optical 1
    opticalr_data = [right_x' right_y'];% make a matrix of delta_x and delta_y movements of optical2
    currentl_pos = in.previous_l_position{in.n}(1,:);%get current position of (-1.5,0). First row of matrix
    currentr_pos = in.previous_r_position{in.n}(1,:);%same as above for right optical(1.5,0)
    angle = atan2d((currentr_pos(2) - currentl_pos(2)),(currentr_pos(1)-currentl_pos(1)));%calculating the slope
    indeg_currentangle = (angle)+90;%taninv(slope) gives slope angle. This angle + 90  gives robot orientation
    prevl_position = currentl_pos;% store the current left optical position as prev for next calculation
    prevr_position = currentr_pos;% store the current right optical position as prev for next calculation
   % checking for robot YAW
%     for o=1:(min(length(opticalr_data),length(opticall_data)))-1
%         if( Robot_Yaw{o+1}>Robot_Yaw{o}+40 ||  Robot_Yaw{o+1}<Robot_Yaw{o}-40)
%             Robot_Yaw{o+1}=Robot_Yaw{o}
%         end
%     end
    for o=1:(min(length(opticalr_data),length(opticall_data))) %this for loop will have to changed appropriately based on how the data is read.
        currentl = opticall_data(o,:);%read a new row which has (delta_x,delta_y) values and make it a matrix
        currentr = opticalr_data(o,:);
        %The line below calculates the new position based on previous
        %coords,previous angle subtended and current (x,y) movements- for left
        %optical
        indeg_currentangle=Robot_Yaw{o}+in.yaw_offset(in.n); % using the Yaw for angle correction
        currentl_pos = [(prevl_position(1) + (currentl{1}*sind(indeg_currentangle)) +(currentl{2}*cosd(indeg_currentangle))) (prevl_position(2) + (currentl{2}*sind(indeg_currentangle)) + (currentl{1}*cosd(indeg_currentangle)))];
        %Same as above but for right optical
        currentr_pos = [(prevr_position(1) + (currentr{1}*sind(indeg_currentangle)) +(currentr{2}*cosd(indeg_currentangle))) (prevr_position(2) + (currentr{2}*sind(indeg_currentangle)) + (currentr{1}*cosd(indeg_currentangle)))];
%         angle = atan2d((currentr_pos(2) - currentl_pos(2)),(currentr_pos(1)-currentl_pos(1)));%Finding slope
        %         indeg_currentangle = ( angle)+90; %converting to deg
        prevl_position = currentl_pos; %remember new position
        prevr_position = currentr_pos;%remember new posotion
        robot_x_poisition(o)=(currentl_pos(1)+currentr_pos(1))/2;
        robot_y_poisition(o)=(currentl_pos(2)+currentr_pos(2))/2;
        robot_theta(o)=indeg_currentangle;
        l_optical_movement(o,:)=currentl_pos;   % for plotting the data of the left optical
        r_optical_movement(o,:)=currentr_pos;     % for plotting the data of the right optical
    end
    % out.previous_mice_time=in.synch_data.right_optical_sync.time;
    out.mice_x =robot_x_poisition;
    out.mice_y = robot_y_poisition;
    out.mice_theta = robot_theta;
    out.previous_l_position{in.n}= currentl_pos;
    out.previous_r_position{in.n}=currentr_pos;
    out.heading_difference=robot_theta;
    % to be removed later only for debugging, plotting the optical data
    out.l_optical_movement=l_optical_movement;
    out.r_optical_movement=r_optical_movement;
catch
    a=lasterror
    keyboard
end

end


