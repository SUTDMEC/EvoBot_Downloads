function remote_control(robot_h)

%Remote control functionality: Uncomment the code below to control the
  %robot in remote control mode
  bot_ip=input('5 for straight, 1 for left, 3 for right, 2 for back');
  if bot_ip==5
      cmd='w100;100;10000;';%move straight at full speed for 10 s
  elseif bot_ip==2
      cmd='w-100;-100;1000;';%move back at full speed for 1 s
  elseif bot_ip==3
      cmd='w100;50;1000;';%Turn right with right wheel at half speed
  elseif bot_ip==1
      cmd='w50;100;1000;';%Turn left with left wheel at half speed
  else cmd='w100;100;1000;';%Move forward at max speed for 1s
  end
%    cmd=('w100;30;200;');

robot_h.write(1,cmd)
end