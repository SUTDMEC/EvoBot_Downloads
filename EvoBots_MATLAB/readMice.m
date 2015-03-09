   function [left,right] =readMice(left_fileID,right_fileID,start_run,end_run)

% left_fileID - file ID assigned to the mouse on the master base station
% right_fileID - file ID assigned by the satellite computer
% start_run - motion run start time
% end_run - end time of motion run
% left_next_row - last row called left
% right_next_row - last row called right


%read left mouse file
[time, dx, dy]=readMouseFile(left_fileID,start_run,end_run);
left.time = time;
left.dx = dx;
left.dy = dy;
%read right mouse file
% keyboard %wait until dropbox loads the file
[time, dx, dy]=readMouseFile(right_fileID,start_run,end_run);
right.time = time;
right.dx = dx;
right.dy = dy;
end