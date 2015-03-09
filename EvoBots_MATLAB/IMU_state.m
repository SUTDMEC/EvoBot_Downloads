function out = IMU_state (in)
try
% this function calculates dx, dy, and dtheta from accelerometer & gyro
% information

%imu theta calc
s_length = length(in.sense_data{end}); % extracting the sensor required data
% all the sensor data was stored in in.data{i}.sens_data where i is the ith
% iteration of the sensor loop while one motor command was being executed
sense_time=[];
headings=[];
accx=[];
accy=[];

%assume that each run always starts from rest
dx0=0;
dy0=0;

for i=2:(s_length-1)
    sense_time=[sense_time;in.data{i}.sens_time];
    headings = [headings;in.data{i}.sens_data{12}];
    accx = [accx;in.data{i}.sens_data{3}];
    accy = [accy;in.data{i}.sens_data{4}];
end
%keyboard
dtime=diff(sense_time)*24*3600;

out.theta= headings; %difference in calculated headings divided by difference in time, in seconds

%imu dx/dy calc
dxvel = dx0 + cumtrapz(dtime,accx(2:end)); %time integral using trapezoidal rule giving velocity in m/s
%dxdisp = in.x0 + cumtrapz(dxvel);%2nd integral giving displacement in m
dxdisp = cumtrapz(dxvel);%2nd integral giving displacement in m


out.x=in.x(end)+dxdisp;

dyvel = dy0 + cumtrapz(dtime,accy(2:end));%time integral using trapezoidal rule giving velocity in m/s
%dydisp = in.y0 + cumtrapz(dyvel);%2nd integral giving displacement in m
dydisp = cumtrapz(dyvel);%2nd integral giving displacement in m

out.y=in.y(end) + dydisp;
% keyboard
catch
    a=lasterror
    keyboard
    
end
end