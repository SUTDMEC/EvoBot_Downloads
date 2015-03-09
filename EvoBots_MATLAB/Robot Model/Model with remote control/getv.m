function [V1, V2]=getv(target,actual_th,state)

P=100;
I=0;%0.01;
d=0.001;



error_th=target-actual_th;
s=size(state);
if s(2)<2
    actual_th_state=state(5);
else actual__th_state=state(:,5);
end
deltaV=P*error_th+I*sum(target-actual_th_state);%P control
if deltaV>5/4
    deltaV=5/4;
end

V1=deltaV;%+deltaV_dist;
V2=-deltaV;%+deltaV_dist;

