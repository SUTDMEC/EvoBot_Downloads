function [left right] =read_mouse_file(left_fileID,right_fileID,start_run,end_run,left_next_row, right_next_row)

% left_fileID
% right_fileID
% start_run
% end_run
% left_next_row
% right_next_row



[time dx dy]=readMouseFile(id,start_run,end_run,next_row);

left.time 
left.dx 
left.dy 
left.lastrow 
right.time 
right.dx 
right.dy 
right.lastrow

  a=importdata(fopen(in.mouseFID));
  a1=a.textdata(6:length(a.textdata),:);
  a2=a.data;
  t=a1(:,1);
  for i=1:length(t)
  time(i) = datenum(t(i),'HH:MM:SS:FFF');
  end
dx=a2(:,1);
dy=a2(:,2);
end    