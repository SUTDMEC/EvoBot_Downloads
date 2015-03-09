%Sample Call:
% [a,b,c]=remote_ctrl(pi,[0;0;0;0;0;0;0])
function [orientation,allstates,alltimes]=remote_ctrl(target_angle,initial_state)
global TA
allstates=[];
alltimes=[];
TA=target_angle;
%%%%%%%%Model for 1s%%%%%%%%%%%%%%
last_state=initial_state;
while  abs(target_angle-last_state(5))>0.1% abs(target_angle-last_state(5))>0.01 ||

tspan=[0,0.1];
%while the target distance and target state are not met, continue to use
%robot model ode23- Need to remember previous distance covered and target
%angle

[t,x] = ode23('test_ode5', tspan, last_state);
allstates=[allstates;x];
if length(alltimes)==0
    alltimes=t;
else 
alltimes=[alltimes;t+alltimes(end)];
end
last_state=x(end,:);
end

%final_state=x;
%orientation=x(end,5);
orientation=0;
x=allstates;
t=alltimes;
test_plot5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%