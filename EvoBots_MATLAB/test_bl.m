% Find a Bluetooth connection object.
obj1 = instrfind('Type', 'bluetooth', 'Name', 'Bluetooth-Evobot_36:1', 'Tag', '');
pause(8)
% Create the Bluetooth connection object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = Bluetooth('Evobot_36', 1);
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);
pause(2)
% Communicating with instrument object, obj1.
fprintf(obj1, '%c', '&');
pause(0.05)
fprintf(obj1, '%c', 'w');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', '5');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', ';');
pause(0.05)
fprintf(obj1, '%c', '2');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', ';');
pause(0.05)
fprintf(obj1, '%c', '1');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', '0');
pause(0.05)
fprintf(obj1, '%c', ';');
    fclose(obj1);
