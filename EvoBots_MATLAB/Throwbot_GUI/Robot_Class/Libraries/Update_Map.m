function Update_Map()
%     MapHere = evalin('base','Map_Data');
%     gui_h = evalin('base','Gui_Handles');
%     
%     scatter(gui_h.ha,MapHere(i).encoder_state(1),MapHere(i).encoder_state(2));
    Robot = evalin('base','x');
    Robot.Update_Map

end