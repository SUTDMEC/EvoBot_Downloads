function myfunct1(hObject, eventdata, handles, varargin)
global y x
x = 0:.1:3*pi; % Make up some data and plot
y = sin(x);
handles.plot = plot(handles.axes1,x,y);
handles.timer = timer('ExecutionMode','fixedRate',...
                    'Period', 0.5,...
                    'TimerFcn', {@GUIUpdate,handles});
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
global y x
start(handles.timer)
for i =1:30
   y = sin(x+i/10); 
   pause(1) 
end

function GUIUpdate(obj,event,handles)
global y 
set(handles.plot,'ydata',y);