
in.mouseFID= fopen(strcat('mouse_data',datestr(now,'yy_mm_dd_HH_MM'),'.txt'),'wt');
ScreenSize = get(0,'ScreenSize');
hFig = figure('units','normalized','outerposition',[0 0 1 1]);

in.ScreenSize=ScreenSize;

fprintf(in.mouseFID,'Evobot Gen01 - Mouse Stream, Time Commenced:');

fprintf(in.mouseFID,datestr(clock));

fprintf(in.mouseFID,'\n\r\n\rTime\tdx\tdy\t\n\r');


in.mouse_constant=376; %mouse-dependent scaling parameter to get distance travelled in m


%set mouse to center coordinates as initialization code

set(0,'PointerLocation',[ScreenSize(3)/2,ScreenSize(4)/2])

%hide mouse pointer
set(hFig, 'pointer', 'custom', 'PointerShapeCData', nan(16, 16))

%initialize timerObject

timerObj = timer('TimerFcn',{'opticmouse_2',in}, 'Period',0.1,'ExecutionMode','fixedRate','Tag','MouseTime'); %check the mouse position every 10 ms
start(timerObj);
