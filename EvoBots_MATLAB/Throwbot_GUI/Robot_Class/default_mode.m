function default_mode( robot_h)
%Default mode: Robot just moves straight

    duration=1000;

    cmd=strcat('w',num2str(round(100)),';',num2str(round(100)),';',num2str(duration),';');
    robot_h.write(1,cmd);
%     toc
end

