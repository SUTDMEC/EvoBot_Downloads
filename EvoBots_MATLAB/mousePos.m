function mousePos(timerObj,event,str_arg)
coords = get(0,'PointerLocation');
timerObj.UserData = coords;
end
