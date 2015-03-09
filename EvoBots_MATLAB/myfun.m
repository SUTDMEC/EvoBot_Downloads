function myfun(obj, event, x, y, z)
% Real math here
val = x + y + z ;

coords = get(0,'PointerLocation');

obj.UserData = coords;

