function command_send(robot_h,v1,v2,dt_ms,botnum)

cmd=strcat('w',num2str(round(v2)),';',num2str(round(v1)),';',num2str(100),';');

robot_h.write(botnum,cmd);