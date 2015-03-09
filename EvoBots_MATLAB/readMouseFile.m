function [time, dx, dy]=readMouseFile(id,start_run,end_run)
%readMouseFile opens the data from the last run
%   finds the time which matches the run time, returns the data and the
%   last row which it worked on in order to be more efficient

%try
    if ~isa(id,'char')
        %     data=csvread(fopen(id),next_row,0); %when reading from left mouse
        data=csvread(fopen(id)); %open entire file now
    else
        %     data=csvread(id,next_row,0); %case when reading from right mouse
        data=csvread(id); %open entire file now
    end
    
    time=data(:,1);
    
    [~, start_idx] = min(abs(time - start_run)); %find the closest time in the mouse file to when we started the run
    
    
    [~, end_idx] = min(abs(time - end_run)); %find the closest time in the mouse file to when we ended the run
    
    %return the values parsed for the run start and end time
    
    time=time(start_idx:end_idx);
    dx=data(start_idx:end_idx,2);
    dy=data(start_idx:end_idx,3);
%     keyboard

    if length(time)==1
        keyboard
    end
% catch
%     a=lasterror
%     keyboard
% end

end

