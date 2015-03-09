function  out = slam_map(in)        % gives out an array of cordinates of landmark locations
try
for m= 1:(length(in.data(in.n,:))-1)
        Left_IR(m)= in.data{in.n,m}.sens_data(4);
        Centre_IR(m)= in.data{in.n,m}.sens_data(5);
        Right_IR(m)= in.data{in.n,m}.sens_data(6);
    end
    
  sensor_array = [Left_IR'  Centre_IR' Right_IR']; % Saving all SEnsor IR data into an array
X_cordinates= in.x{in.n};                             %saving the x_cordinates in an array 
Y_cordinates= in.y{in.n};                             %saving the y_cordinates in an array 
robot_orientation=in.theta{in.n};
%figure out if synch has shortened one or the other values
sensor_size=size(sensor_array);
sens_array_len=sensor_size(1); %take the size of the sensor array data
loop_len=min(length(X_cordinates),sens_array_len);
landmark_y_location=zeros(1,loop_len);
landmark_x_location=zeros(1,loop_len);
sensetest2=cell2mat(sensor_array(:,2));
sensetest1=cell2mat(sensor_array(:,1));
sensetest3=cell2mat(sensor_array(:,3));
my_minimum= min(length(sensetest2),length(sensetest1));
loop_length2= min(my_minimum,length(sensetest3));
for p=1:loop_length2       %running the loop till the length of sensor array
%     sensetest=cell2mat(sensor_array(:,2));
    if((sensetest2(p)<400) && (sensetest2(p)>250) && (sensetest2(p)~=-1))  %looking for obstacle from centre IR
        
        %In case anything detected then saving the x, y location of the
        %obstacle
        
        landmark_y_location(in.k)=Y_cordinates(p)+(sensor_array{p,2})*sind(robot_orientation(p));
        landmark_x_location(in.k)=X_cordinates(p)+(sensor_array{p,2})*cosd(robot_orientation(p));
        %scatter((landmark_x_location),landmark_y_location)
        in.k=in.k+1;
    end
    
    if(sensetest1(p)<400 && sensetest1(p)>240 && sensetest1(p)~=-1)      %looking for obstacle from Left IR
     
        
        %In case anything detected then saving the x, y location of the
        %obstacle
        
        landmark_y_location(in.k)=Y_cordinates(p)+(sensor_array{p,1}*sind(robot_orientation(p)+72));
        landmark_x_location(in.k)=X_cordinates(p)+(sensor_array{p,1}*cosd(robot_orientation(p)+72));
        %scatter((landmark_x_location),landmark_y_location)
        in.k=in.k+1;
    end
    if(sensetest3(p)<400 && sensetest3(p)>240 && sensetest3(p)~=-1)      %looking for obstacle from Right IR
       
        
        %In case anything detected then saving the x, y location of the
        %obstacle
        
        landmark_y_location(in.k)=Y_cordinates(p)+(sensor_array{p,3}*sind(robot_orientation(p)-72));
        landmark_x_location(in.k)=X_cordinates(p)+(sensor_array{p,3}*cosd(robot_orientation(p)-72));
        %scatter((landmark_x_location),landmark_y_location)
        in.k=in.k+1;
    end
end
out.landmark_y_location=landmark_y_location;
out.landmark_x_location=landmark_x_location;
catch
    a=lasterror
    keyboard
end
end