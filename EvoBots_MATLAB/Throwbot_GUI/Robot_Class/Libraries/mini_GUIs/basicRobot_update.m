function basicRobot_update(handles)
robot_handle = handles.Robot_h
map_handle = handles.map_window

if robot_handle == -1   %if robot class is not connected; do nothing
    a = 1234
    return
else
    %update the robot object
    status = robot_handle.update;
    %update the map
    robot_handle.Update_Map(map_handle);
end
end

