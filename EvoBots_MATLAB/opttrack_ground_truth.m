basedir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\';
% filename='Take 2014-04-23 08.41.11 AM.xlsx'; % 50 second rotation
% filename='Take 2014-04-23 08.43.36 AM.xlsx'; % x 5 second rotations
filename='Take 2014-04-23 08.57.53 AM.xlsx'; %2,4,6,8 second rotations

raw=importdata(strcat(basedir,filename));

idx=find(ismember(raw.textdata.Take(:,1),'frame'));

time=raw.data.Take(idx,2);
x=raw.data.Take(idx,5);
y=raw.data.Take(idx,6);
z=raw.data.Take(idx,7);

roll=raw.data.Take(idx,12); %in degrees
pitch=raw.data.Take(idx,13); %in degrees
yaw=raw.data.Take(idx,14); %in degrees

figure
plot(time,roll);

figure
plot(x,y,'*')