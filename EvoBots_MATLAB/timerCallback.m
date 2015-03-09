function out= timerCallback(timerObj,event,str_arg)
% this function is executed everytime the timer object triggers.<
% read the coordinates
fileID = fopen('hello.txt','w');
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

if(coords(1) ~= midpoint_xy(1) && coords(2) ~= midpoint_xy(2))
%set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]); 
rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
rel_distancecm = [rel_distancematrix(1)/376 rel_distancematrix(2)/376];
distance_x_moved=rel_distancematrix(1)/376-previous_x_position;
distance_y_moved=rel_distancematrix(2)/376-previous_y_position;
previous_x_position= rel_distancematrix(1)/376;
previous_y_position= rel_distancematrix(2)/376;
%current_x_position=previous_x_position+distance_x_moved+moved_x_outofscreen;
%current_y_position=previous_y_position+distance_y_moved+moved_y_outofscreen;
current_x_position=rel_distancematrix(1)/376+moved_x_outofscreen;
current_y_position=rel_distancematrix(2)/376+moved_y_outofscreen;
position = [current_x_position current_y_position];
fprintf(fileID,'%6.2f 12.8f\n',position);
scatter(current_x_position,current_y_position)
axis([-15 15 -20 20]);
hold on;
pause(0.008);
fprintf(fileID,'%4i\n',rel_distancecm);
%distance = norm( rel_distancecm);
%fprintf('Distance travelled: %4i',distance);
end

if(coords(1) == 1366 || coords(2) == 768 || coords(1)== 1 || coords(2) == 1 || coords(1) == 683 || coords(2) == 384)
   %coords = get(0,'PointerLocation');
   rel_distancematrix = [coords(1)-midpoint_xy(1) coords(2)-midpoint_xy(2)];
   rel_distancecmtop = [rel_distancematrix(1)/376 rel_distancematrix(2)/376];
   moved_x_outofscreen=current_x_position;
   moved_y_outofscreen=current_y_position;
   %distance_top = norm( rel_distancecm);
   flag_set = 1; 
   set(0,'PointerLocation',[midpoint_xy(1) midpoint_xy(2)]); 
end

coords2 = get(0,'PointerLocation');

if(flag_set == 1 && coords2(1) ~= 683 && coords2(2) ~= 384)
   %coords = get(0,'PointerLocation');
   rel_distancematrix = [coords2(1)-midpoint_xy(1) coords2(2)-midpoint_xy(2)];
   rel_distancecmtopcontin = [rel_distancematrix(1)/376 rel_distancematrix(2)/376];
   rel_distancecmtcontin = rel_distancecmtop + rel_distancecmtopcontin;
   %fprintf(fileID,'%4i\n',rel_distancecmtcontin);
   %distance_topcontin = norm( rel_distancecm);
   %fprintf('Distance travelled total: %4i',distance_top+ distance_topcontin);

end 
end
fclose(fileID);
end
