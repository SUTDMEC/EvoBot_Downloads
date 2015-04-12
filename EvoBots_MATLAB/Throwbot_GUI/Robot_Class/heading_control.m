function [angle_changed,angle_reached]=heading_control(bot,ref,curr,bot_num,angle_reached,numbots)
if abs(ref(bot_num)-curr)>0.1
    u_base=40;
    Kp=30;
    du=Kp*(curr-ref(bot_num));
    cmd=strcat('w',num2str(round(du+u_base)),';',num2str(round(-du+u_base)),';',num2str(200),';');
    bot.write(1,cmd);
    angle_reached(bot_num)=0;
    angle_changed=1;
else u_base=50;
    angle_reached(bot_num)=1;
    cmd=strcat('w',num2str(round(u_base)),';',num2str(round(u_base)),';',num2str(300),';');
    bot.write(1,cmd);
    angle_changed=0;
end

% if isequal(angle_reached,ones(1,numbots))
%     angle_changed=0;
% else angle_changed=1;
% end
