function [heading_ok]=heading_ctrl(bot,ref,curr)
curr=wrapTo2Pi(curr);
ref=wrapTo2Pi(ref);
error=(ref-curr);

if abs(error)>0.1
    heading_ok=0;
    Kp=30;
    du=Kp*error;
    cmd=strcat('w',num2str(round(-du)),';',num2str(round(du)),';',num2str(200),';');
    bot.write(1,cmd);
else
    heading_ok=1;
end