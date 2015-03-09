function out = synchEvo (in)
try
%inputs:
%in.optical_x=vector of optical dx values
%in.optical_y=vector of optical dy values
%in.optical_time=vector of optical timestamps
%in.data=cell array of sensor values
%in.picture = vector of timestamps
%in.passthrough = a flag to signal that the values should be passed through
leftoptical=timeseries([in.l_optical_x in.l_optical_y],in.l_optical_time); %create ts object for optical data
rightoptical=timeseries([in.r_optical_x in.r_optical_y],in.r_optical_time); %create ts object for optical data

sens_time = zeros((length(in.data)-2),1);
sens_data = zeros((length(in.data)-2),12);
for i=2:length(in.data)-1
    sens_time(i-1,1) = [in.data{i}.sens_time];
    sens_data(i-1,:) = [cell2mat(in.data{i}.sens_data)];
end
sensor=timeseries(sens_data,sens_time); %create tst object of sensor data
% pics=timeseries((1:length(in.picture))',in.picture); %create picture order from an ordered list
if in.passthrough
    %check to see that enough data is available to process
    if length(leftoptical.time)<3 || length(rightoptical.time)<3 || length(sensor.time)<3 %|| length(pics.time)<3
        out.empty.flag=1;
    else
        out.empty.flag=0;
    end
    
    out.left_optical_sync=leftoptical;
    out.right_optical_sync=rightoptical;
    out.sen_sync_left=sensor;
%   out.pic_sync=pics;
    return
end

%function assumes an input of optical, sensor & image
out.empty.flag=0;

if isempty(leftoptical.time)
    out.empty.flag=1;
    out.empty.ts='leftoptical';
    out.empty.intime=in.l_optical_time;
    out.empty.indata=[in.l_optical_x in.l_optical_y];
    return
end


if isempty(rightoptical.time)
    out.empty.flag=1;
    out.empty.ts='rightoptical';
    out.empty.intime=in.r_optical_time;
    out.empty.indata=[in.r_optical_x in.r_optical_y];
    return
end




if isempty(sensor.time)
    out.empty.flag=1;
    out.empty.ts='sensor';
    out.empty.intime=sens_time;
    out.empty.indata=sens_data;
    return
end

[left_optical_sync, right_optical_sync]=synchronize(leftoptical,rightoptical,'union'); %synch left and right mice
[left_optical_sen_sync, sen_sync_left]=synchronize(left_optical_sync,sensor,'union'); %synch left optical and sensor (already common time with right optical)
[right_optical_sen_sync, sen_sync_right]=synchronize(right_optical_sync,sensor,'union'); %synch left optical and sensor (already common time with right optical)


if isempty(pics.time)
    out.empty.flag=1;
    out.empty.ts='pics';
    out.empty.intime=in.picture;
    out.empty.indata=(1:length(in.picture))';
    return
end

if isempty(left_optical_sen_sync.time)
    out.empty.flag=1;
    out.empty.ts='left_optical_sen_sync';
    out.empty.ts1=left_optical_sync;
    out.empty.ts2=sensor;
    return
end

if isempty(sen_sync_left.time)
    out.empty.flag=1;
    out.empty.ts='sen_sync_left';
    out.empty.ts1=left_optical_sync;
    out.empty.ts2=sensor;
    return
end

if isempty(right_optical_sen_sync.time)
    out.empty.flag=1;
    out.empty.ts='right_optical_sen_sync';
    out.empty.ts1=right_optical_sync;
    out.empty.ts2=sensor;
    return
end

if isempty(sen_sync_right.time)
    out.empty.flag=1;
    out.empty.ts='sen_sync_right';
    out.empty.ts1=right_optical_sync;
    out.empty.ts2=sensor;
    return
end

out.left_optical_sync=left_optical_sync;
out.right_optical_sync=right_optical_sync;
out.sen_sync_left=sen_sync_left;

[left_all_sync, pic_sync]=synchronize(left_optical_sen_sync,pics,'union'); %synch optical and sensors and pics

if isempty(pic_sync.time)
    out.empty.flag=1;
    out.empty.ts='pic_sync';
    out.empty.ts1=left_optical_sen_sync;
    out.empty.ts2=pics;
    return
end

if isempty(left_all_sync.time)
    out.empty.flag=1;
    out.empty.ts='left_all_sync';
    out.empty.ts1=left_optical_sen_sync;
    out.empty.ts2=pics;
    return
end

out.pic_sync=pic_sync;

% keyboard
%out.time=all_sync.time; %output the common timestamp
%out.data=all_sync.data; %output the synchrnoized data
%out.pic_names=all_sync.data(:,end); %output a special vector of the rearranged picture names

%out.time = common timestamp
%out.data = 11 columns  -10 from sensors, 1 from pictures
%out.pic_names = column 11 of the output data
catch
    a=lasterror
    keyboard
end