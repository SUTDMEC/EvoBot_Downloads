%this function has to be called only once when you change the number of
%robot and make sure you change the numbering depending on the numbner of
%robots, i.e starting from s(1),s(2)... s(7) in case of 7 robots
robot_num=2;
s(1) = Bluetooth('Evobot_01',1);
print= 'robot1_configured'
% s(2) = Bluetooth('Evobot_21',1); %Setting the bluetooth port for each robot
% print= 'robot21_configured'
s(2) = Bluetooth('Evobot_36',1);
print= 'robot36_configured'
% s(5) = Bluetooth('Evobot_05',1);
% print= 'robot6_configured'
% s(6) = Bluetooth('Evobot_03',1);
% print= 'robot7_configured'
% s(7) = Bluetooth('Evobot_30',1);
% print= 'robot9_configured'
