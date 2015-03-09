function opticmouse_wplot(mouse_constant,scatterplot_xmin, scatterplot_xmax, scatterplot_ymin, scatterplot_ymax,plot_pausetime)
	
	current_x_position=0;
	current_y_position=0;
	previous_x_position=0;
	previous_y_position=0;
	distance_x_moved=0;
	distance_y_moved=0;
	moved_x_outofscreen=0;
	moved_y_outofscreen=0;
	
	while(1)
	flag_set = 0;
	screensize = get(0,'ScreenSize');
	coords = get(0,'PointerLocation');
	midpoint_xy = [screensize(3)/2 screensize(4)/2];
	
	if(coords(1) ~= midpoint_xy (1) && coords(2) ~= midpoint_xy (2))
	rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
	distance_x_moved=rel_distancematrix(1)/mouse_constant-previous_x_position;
	distance_y_moved=rel_distancematrix(2)/mouse_constant-previous_y_position;
	previous_x_position= rel_distancematrix(1)/mouse_constant;
	previous_y_position= rel_distancematrix(2)/mouse_constant;
	current_x_position=rel_distancematrix(1)/mouse_constant + moved_x_outofscreen;
	current_y_position=rel_distancematrix(2)/mouse_constant + moved_y_outofscreen;
	scatter(current_x_position,current_y_position)
	axis([scatterplot_xmin  scatterplot_xmax scatterplot_ymin scatterplot_ymax]);
	hold on;
	pause(plot_pausetime);
	end
	
	if(coords(1) == screensize(3) || coords(2) == screensize(4) || coords(1)== 1 || coords(2) == 1 || coords(1) == midpoint_xy (1) || coords(2) == midpoint_xy (2))
	   rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
	   moved_x_outofscreen=current_x_position;
	   moved_y_outofscreen=current_y_position;
	   flag_set = 1; 
	   set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]); 
	end
	
	coords2 = get(0,'PointerLocation');
	
	if(flag_set == 1 && coords2(1) ~= midpoint_xy(1) && coords2(2) ~= midpoint_xy(2))
	   rel_distancematrix = [coords2(1)-midpoint_xy(1) coords2(2)-midpoint_xy(2)];
	end
	  
	end
	end?
