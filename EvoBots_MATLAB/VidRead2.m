 function VidRead2(time_st,time_end)

%Read Files in the folder

folder_content=dir;
i=1;
%j=0;
%l=length(folder_content);
while i<length(folder_content)
    
    if folder_content(i).name((length(folder_content(i).name-3):end))~='avi'
        i=i+1;
    else

        break
    end

end
%%%%%%%%%%t1 needs to be initialized in an earlier part of the
%%%%%%%%%%code%%%%%%%%%%%%%%%%%%
initial_hrs=str2num(folder_content(i).name(10:11));
initial_min=str2num(folder_content(i).name(12:13));
initial_sec=str2num(folder_content(i).name(14:15));

t1=initial_hrs*3600+initial_min*60+initial_sec;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 t2=t1+time_st;
 t3=t1+time_end; 
vid_start=t2-t1;
vid_end=t3-t1;
vid=mmread(folder_content(i).name,[], [vid_start*2.11 vid_end*2.11]);

movie(vid.frames)

%Need to extract images from the 