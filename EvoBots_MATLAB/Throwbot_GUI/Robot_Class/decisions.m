function [mov_theta]=decisions(current_pos,final_map,map_x,map_y,weights,resolution,n_bots)

%Take current_pos and draw 5 lines away from it for 300mm, If it intersects a
%non zero cost, record the cost, distance and add it to local_rewards
r=300*resolution;
obst_map=final_map;
s=size(final_map);
num_dir=5;
explore_penalty=1;%0.5;
local_penalty=1;
max_cost=0;
for i=0:num_dir
    angle=2*pi*i/num_dir+18*pi/180;
    if i==num_dir
        r=0;
    end
    check_pts=[current_pos(1)+round(r*cos(angle)) current_pos(2)+round(r*sin(angle))];
    for j=(check_pts(1)-(50*resolution)):(check_pts(1)+(50*resolution))
        for k=(check_pts(2)-(50*resolution)):(check_pts(2)+(50*resolution))
            if j<=s(1)&&k<=s(2)&&j>0&&k>0
                max_cost=max(max_cost,obst_map(j,k));
            end
        end
    end
    local_costs(i+1)=max_cost;
    max_cost=0;
%     if check_pts(1)<=s(1)&&check_pts(2)<=s(2)&&check_pts(1)>0&&check_pts(2)>0
%     local_map(i+1)=obst_map(check_pts(1),check_pts(2));
%     else local_map(i+1)=0;
%     end
end
r=300*resolution;
for i=1:length(local_costs)
    gamma=0.8;
    local_costs(i)=local_costs(end)+gamma*local_costs(i);
end
local_costs=local_penalty*(local_costs);
%Global costs
%Calculate centroid of final map(includes obstacle and visit costs) and
%calculate sum(wi*xi) and claculate direction opposite to net torque
xc=sum(map_x)/length(map_x);
yc=sum(map_y)/length(map_y);
tor_x=weights'*(map_x-xc);
tor_y=weights'*(map_y-yc);
x_b=-length(weights)*tor_x/(sum(weights));
y_b=-length(weights)*tor_y/(sum(weights));
% expl_dir=atan2(tor_y,tor_x);
% for i=0:(length(local_costs)-1)
%     explore_penalty=500;
%     angle=2*pi*i/5+18*pi/180;
%     global_costs(i+1)=explore_penalty*abs(angle-expl_dir);
% end
for i=0:num_dir
    angle=2*pi*i/num_dir+18*pi/180;
    if i==num_dir
        r=0;
    end
    dist(i+1)=norm([current_pos(1)+round(r*cos(angle)) current_pos(2)+round(r*sin(angle))]-[x_b y_b]);
end
global_costs=explore_penalty*dist;
total_cost=local_costs+global_costs;

min_cost=min(total_cost);
dir=find(min_cost==total_cost);
if length(dir)>1
    dir=dir(randi(length(dir)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theta=pi/10+(2*pi/(length(total_cost)-1))*(dir-1);
for i=1:n_bots
    mov_theta(i)=theta+(i-1)*2*pi/n_bots;
end

% mov_theta=theta;
% local_costs

