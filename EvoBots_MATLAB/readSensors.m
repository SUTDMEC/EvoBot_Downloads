
function  out = readSensors(in)
try
    %readSensors - receives the sensor/bt stream from the robot, sets up flags
    %according to if motor command is being executed, if obstacles have been
    %encountered, writes the data out to a textfile
    %estimation
    %   Detailed explanation goes here
    str=fscanf(in.s(in.n));
    if(length(str)==1 || isempty(str))% check if the string is not empty
        
        print='couldnt read'
        out.command_running = 1;
        out.interrupt = 0;
        out.read=0;
    else
        out.read=1;
        temp = strsplit(str,';'); %each sensor reading is split by a semi-colon
        num = size(temp);
        if(strcmp(temp{2},'STOPPED'))%IF the robot moves for the set duration
            out.command_running = 0;
            out.interrupt = 0;
        elseif(strcmp(temp{2},'OBSTACLE')) % if the robot sees an obstacle in between
            out.command_running = 1;
            out.interrupt = 1;
        else
            out.interrupt = 0;
            out.command_running = 1;
            data={}; %'data' will store the information that gets saved in matlab and forwarded to whereever required
            data_print={}; %'data_print' will store the information as strings so we can save it to the textfile
            seconds=str2num(temp{2});
            st=addtodate(in.time_start,seconds,'millisecond');
            data{1}=st;
            out.sens_time=data{1}; %keep track of the data in a matlab struct for time-syncing later
            st=datestr(addtodate(in.time_start,seconds,'millisecond'),'HH:MM:SS:FFF'); %time stamp
            data_print{1}=st;
            
            for i=1:num(2)-2
                x= temp{i+1};
                data{i}=str2num(x);
                data_print{i}=x;
            end
            
            fprintf(in.fileID(in.n), '\n%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', data_print{:}); %saving to the text file
            out.sens_data = data(1:min((num(2)-1),13));
        end
        
    end
catch
    a=lasterror
    keyboard
end
end