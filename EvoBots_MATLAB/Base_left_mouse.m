%Mouse

%listen for timestamp from Master PC (leftmouse)
% 
% ipstr='192.168.48.68'; %IP address of Master PC
% 
% timeout=EvoClient(ipstr);

% in.offset=datenum(clock)-timeout;

%initialize left mouse file ID (right mouse is running on different machine
dir='Z:\Temasek Laboratories\STARS\LeftMouse\';
in.mouseFID= fopen(strcat(dir,'left_mouse_data',datestr(now,'yy_mm_dd'),'.csv'),'wt');
%Note: this function must be called on the same day as the master base
%station function

ScreenSize=get(0,'ScreenSize');
 hFig=figure('units','normalized','outerposition',[0 0 1 1]) ;
 ButtonHandle = uicontrol('style','push',...
     'callback','set(gcbo,''userdata'',1,''string'',''DONE!'')', ...
     'userdata',0,'position',[ScreenSize(3)/2.05,ScreenSize(4)/2.05 50 50]) ;
% fprintf(in.mouseFID,'Evobot Gen01 - Right Mouse Stream, Time Commenced:');
% fprintf(in.mouseFID,datestr(clock));
% fprintf(in.mouseFID,'\n\r\n\rTime\tdx\tdy\t\n\r');

in.mouse_constant_dy=277; %mouse-dependent scaling parameter to get distance travelled in m
in.mouse_constant_dx=320;
in.ScreenSize=ScreenSize;
%set mouse to center coordinates as initialization code
set(0,'PointerLocation',[ScreenSize(3)/2,ScreenSize(4)/2])
%hide mouse pointer
set(hFig, 'pointer', 'custom', 'PointerShapeCData', nan(16, 16))
%initialize timerObject
timerObj = timer('TimerFcn',{'opticmouse_base',in}, 'Period',0.05,'ExecutionMode','fixedRate','Tag','MouseTime'); %check the mouse position every 10 ms
start(timerObj);

i=1;
while(1) %path planning loop - Robot is stopped
    
%     MAY BE NECESSARY TO SIGNAL TO REMOTE DEVICE TO STOP RECORDING
%     if exist(strcat(dir,'Start.txt'), 'file') == 2 %check if the run is done and the file should be opened and written to
%         in.mouseFID= fopen(strcat(dir,'right_mouse_data',datestr(now,'yy_mm_dd_HH_MM'),'.txt'),'wt');
%         start(timerObj);
%     elseif exist(strcat(dir,'Stop.txt'), 'file') == 2 %pass read/write control to base station
%         stop(timerObj);  
%         fclose(in.mouseFID);
%     end
    pause(0.08);
    set(ButtonHandle,'string',sprintf('%d',i)) ;
    i=i+1;
    if get(ButtonHandle,'userdata'),
        break ;
    end
end

stop(timerObj)

