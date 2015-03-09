  function myfunct(hObject, eventdata, handles)
        current_data = handles.MyStructHere.imu_state;
        scatter(handles.ha,current_data(1),current_data(2));
        a = 123
    end