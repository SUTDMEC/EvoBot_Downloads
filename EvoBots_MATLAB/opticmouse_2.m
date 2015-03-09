function opticmouse_2(timerObj,event,in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    midpoint_xy = [in.ScreenSize(3)/2 in.ScreenSize(4)/2]; %calculate screen 0,0
    coords = get(0,'PointerLocation'); %get current position
    

	%calculate the distance moved in the case that the mouse pointer wasn't reset
     rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
     dx=rel_distancematrix(1)/in.mouse_constant;
     dy=rel_distancematrix(2)/in.mouse_constant;
     
    
     set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]); 
     
     st=datestr(clock,'HH:MM:SS:FFF');
     data{1}=st;
     data{2}=num2str(dx);
     data{3}=num2str(dy);
     fprintf(in.mouseFID, '%s\t%s\t%s\t\n', data{:});

end

