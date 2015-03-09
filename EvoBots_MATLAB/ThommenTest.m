folder_content=dir;
ii=1
while (true)% ii<=length(folder_content)
    folder_content=dir;
    filename = folder_content(ii).name
    [pathstr,name,ext] = fileparts(filename)
    if ~strcmp(ext,'.avi')
        ii=ii+1
        if ii>length(folder_content)
            ii=1;
        end
    else
        a='hello'
        t1_d=datestr(now,'dd-mm-yyyy HH:MM:SS:FFF');
        t1=str2num(t1_d(12:13))*3600+str2num(t1_d(15:16))*60+str2num(t1_d(18:19))+str2num(t1_d(21:23))/1000;
        break
    end
end