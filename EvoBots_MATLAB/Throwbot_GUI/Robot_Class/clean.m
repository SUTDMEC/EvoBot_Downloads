clc
%fclose(s);
for i = 1:robot_num
    x(i).unhookBT;
end
close all
clearvars -except s robot_num

%clear x robot_num print i gui_h ans
% delete(timerfind);
%s = serial('COM1');
% fclose(s);
