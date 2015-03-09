clc
clearvars -except s
delete(timerfind);
%s = serial('COM1');

try fclose(instrfind);
end
clc