clc
clearvars -except s
delete(timerfind);
%s = serial('COM1');
fclose(instrfind);
clc