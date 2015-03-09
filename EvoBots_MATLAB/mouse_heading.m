function [ output_args ] = mouse_theta_test2( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[time1 dx1 dy1] = read_mouse_file('mouse_data14_04_20_03_12.txt'); %read the data file pertaining to mouse1. (Using older version, just for testing purpose)
[time2 dx2 dy2] = read_mouse_file('mouse2_data14_04_20_03_12.txt');% same as above but for mouse2
mousel_data = [dx2 dy2]; %make a matrix of delt_x and delta_y movements of mouse 1
mouser_data = [dx1 dy1];% make a matrix of delta_x and delta_y movements of mouse2

    
    %theta = 90;
    mousel_data(1,1) = -13; %test fixture had length 26 , so left mouse is at(-13,0). so setting initial x component to -13
    mouser_data(1,1) = 13; %same as above for right mouse which is located at (13,0)
    
    currentl_pos = [mousel_data(1,:)];%get current position of (-13,0). First row of matrix
    currentr_pos = [mouser_data(1,:)];%same as above for right mouse
    if(currentr_pos(1)-currentl_pos(1) == 0) %if x2-x1 = 0 just return that the angle is 0
    indeg_currentangle = 0;
    else
    angle = atan((currentr_pos(2) - currentl_pos(2))/(currentr_pos(1)-currentl_pos(1)));%calculating the slope
    indeg_currentangle = (angle*180/pi)+90;%taninv(slope) gives slope angle. This angle + 90  gives robot orientation
    prevl_position = currentl_pos;% store the current position as prev for next calculation
    prevr_position = currentr_pos;%same as above

    end
 for i=2:138 %this for loop will have to changed appropriately based on how the data is read.(Will explain this in detail.... needs some detailed explanation)
     currentl = [mousel_data(i,:)];%read a new row which has (delta_x,delta_y) values and make it a matrix
     currentr = [mouser_data(i,:)];
     %The line below calculates the new position based on previous
     %coords,previous angle subtended and current (x,y) movements- for left
     %mouse
     currentl_pos = [((prevl_position(1)) + (currentl(1)*sind(indeg_currentangle)) +(currentl(2)*cosd(indeg_currentangle))) (prevl_position(2) + (currentl(2)*sind(indeg_currentangle)) + (currentl(1)*cosd(indeg_currentangle)))];
     %Same as above but for right mouse
     currentr_pos = [(prevr_position(1) + (currentr(1)*sind(indeg_currentangle)) +(currentr(2)*cosd(indeg_currentangle))) (prevr_position(2) + (currentr(2)*sind(indeg_currentangle)) + (currentr(1)*cosd(indeg_currentangle)))];
     if(currentr_pos(1)-currentl_pos(1) == 0)
         indeg_currentangle = 0;
     else
     angle = atan((currentr_pos(2) - currentl_pos(2))/(currentr_pos(1)-currentl_pos(1)));%Finding slope
     indeg_currentangle = ( angle*180/pi)+90; %converting to deg
     prevl_position = currentl_pos; %remember new position
     prevr_position = currentr_pos;%remember new posotion
     end
     scatter(currentl_pos(1),currentl_pos(2)); %plotting just for test purpose
     scatter(currentr_pos(1),currentr_pos(2));
     hold on;
     %axis([-3 10 -3 10]);
     pause(0.1);
         
 end
 
    
 
end

