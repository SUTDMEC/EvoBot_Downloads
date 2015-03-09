function [vid, timestamps, imfolder, start_name, end_name ]=readCam(t_start,t_end,i,t1)
% %Read Files in the folder
%
try
date_s=datestr(t_start);
date_s=date_s(12:end);
t2=str2num(date_s(1:3))*3600+str2num(date_s(5:6))*60+str2num(date_s(8:9));
date_e=datestr(t_end);
date_e=date_e(12:end);
t3=str2num(date_e(1:3))*3600+str2num(date_e(5:6))*60+str2num(date_e(8:9));
common_folder = strcat('C:\Users\SUTD\Desktop\Video-Images\');
folder_content=dir(common_folder);

d= dir(strcat(common_folder,'*.avi')); %get all AVIs
dates=[d.datenum]; %get all the timestamps when the vids were created
[~,newest_file]=max(dates); %find the newest

newfile_name=d(newest_file).name; %take the newest name

imfolder=strcat('C:\Users\SUTD\Desktop\Video-Images\',datestr(now,'YY-mm-dd-HHMMSS'),'\');
mkdir(imfolder)

timestampshr=[];
timestampsmin=[];
timestampssec=[];
time_frame_secs=[];
% i=1;
% %j=0;
% %l=length(folder_content);
% while i<length(folder_content)
%
%     if folder_content(i).name((length(folder_content(i).name-3):end))~='avi'
%         i=i+1;
%     else
%
%         break
%     end
%
% end
% %%%%%%%%%%t1 needs to be initialized in an earlier part of the
% %%%%%%%%%%code%%%%%%%%%%%%%%%%%%
% initial_hrs=str2num(folder_content(i).name(10:11));
% initial_min=str2num(folder_content(i).name(12:13));
% initial_sec=str2num(folder_content(i).name(14:15));
%
% t1=initial_hrs*3600+initial_min*60+initial_sec;%t1 is in seconds


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  t2=t1+time_st;
%  t3=t1+time_end; 
 vid_start=t2-t1; 
 vid_end=t3-t1;

vid=mmread(strcat(common_folder,newfile_name),[], [vid_start*2.11 vid_end*2.11]);
% vid.rate
if vid.rate>10
    vid=mmread(strcat(common_folder,newfile_name),[], [vid_start vid_end]);
    vid.frames
%     vid.rate;
end

for i=1:length(vid.times)    
time_frame_secs(i)=t1+(vid.times(i)-vid.times(1));
[timestampshr(i) timestampsmin(i) timestampssec(i)]=sec2hms(time_frame_secs(i));
timestamps(i) = addtodate(datenum(date),time_frame_secs(i)*1000,'millisecond');
end
timestamps=timestamps';
% timestamps=[timestampshr ;timestampsmin; timestampssec];

for i=1:length(vid.frames)
    current_time=clock;
    time_hrs=current_time(4);
    time_min=current_time(5);%str2num(folder_content(i).name(12:13));
    time_sec=1000*current_time(6);%str2num(folder_content(i).name(14:15));
    curr_name=strcat(num2str(time_hrs),num2str(time_min),num2str(time_sec));
    if i==1
    start_name=curr_name;
    end
    %t1=initial_hrs*3600+initial_min*60+initial_sec;
    %imwrite(vid.frames(i).cdata,curr_name);
    imwrite(rgb2gray(vid.frames(i).cdata),strcat(imfolder,curr_name,'.pgm')) % To DO - CONVERT TO UINT8
%      imwrite(vid.frames(i).cdata,strcat(imfolder,curr_name,'.png'),'BitDepth',8)
  
end
end_name=curr_name;
catch
    a=lasterror
    keyboard
end

%movie(vid.frames)