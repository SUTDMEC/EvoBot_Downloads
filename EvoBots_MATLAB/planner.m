function out = planner (in)
%'planner' is the function that will plan the next motor action the robot
%should do based on its previous experiences - if the robot has encountered
%an obstacle the command will be to turn towards the direction with the longest
%traversable path; if no obstacle was found then robot will continue going
%forward
if(in.data{in.n,(length(in.data))}.interrupt==1)%checks if the obstacle interrupt has been turned on
    display('Turn Being Calculated');
    irL = in.data{in.n,(length(in.data(in.n,:))-1)}.sens_data{4}; %checks the irleft reading one iteration before the obstacle was met
    irR = in.data{in.n,(length(in.data(in.n,:))-1)}.sens_data{6};%checks the irright reading one iteration before the obstacle was met
    if(irL==-1 && irR ==-1) %the IR values returns -1 if the distance of the object is more than 70 cms 
        out.R_speed{in.n}='w-100;100;0650;';
    elseif (irL>irR) %if left has a longer path, go left
        if(irR ==-1)
             out.R_speed{in.n}='w100;-100;0600;';
        else
            out.R_speed{in.n}='w-100;100;0600;';
        end
    else
      if(irL ==-1)
             out.R_speed{in.n}='w-100;100;0600;';
        else
            out.R_speed{in.n}='w100;-100;0600;';
        end
    end
else
    out.R_speed{in.n}='w100;100;2000;';
end
end

% pause