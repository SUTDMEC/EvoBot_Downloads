function [map,obst,botx,boty,costmap,max_x,max_y,visit_costmap,counter]=swarm_explore(bot,curr_states,state_hist,bot_num,obst,num_bots,max_x,max_y,visit_costmap,counter)

%Local
IR = bot.data(1).ir_data;
%Check all three IRs for obstacles, If free, assign freespace cost, if not,
%assign obstacle cost
obs_C_x=0;
obs_C_y=0;
obs_L_x=0;
obs_L_y=0;
obs_R_x=0;
obs_R_y=0;
obs_C=[];
obs_L=[];
obs_R=[];
x_add=0;
y_add=0;
obstacle_cost=100;
visitation_cost=0.24*obstacle_cost;

for ir_pos=1:3
    %if free
if IR(ir_pos)<=300&&IR(ir_pos)~=-1
    if ir_pos==2
        obs_C_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos(curr_states{bot_num}(3));
        obs_C_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin(curr_states{bot_num}(3));        
        if obs_C_x~=0||obs_C_y~=0
            obs_C=[obs_C_y,obs_C_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_C_x),round(curr_states{bot_num}(2)+obs_C_y))=obstacle_cost;
    elseif ir_pos==1
        obs_L_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos((-72*pi/180)-curr_states{bot_num}(3));
        obs_L_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin((-72*pi/180)-curr_states{bot_num}(3));
        if obs_L_x~=0||obs_L_y~=0
            obs_L=[obs_L_y,obs_L_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_L_x),round(curr_states{bot_num}(2)+obs_L_y))=obstacle_cost;
    elseif ir_pos==3
        obs_R_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos((72*pi/180)-curr_states{bot_num}(3));
        obs_R_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin((72*pi/180)-curr_states{bot_num}(3));
        if obs_R_x~=0||obs_R_y~=0
            obs_R=[obs_R_y,obs_R_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_R_x),round(curr_states{bot_num}(2)+obs_R_y))=obstacle_cost;
    end
end

end

obst=[obst;obs_C;obs_L;obs_R];




hold on
if length(obst)>0
%     counter=counter+1;
    if min(obst(:,1))<=0||min(obst(:,2))<=0
        x_add=abs(min(obst(:,1)))+1;
        y_add=abs(min(obst(:,2)))+1;
    end
    
    if round((curr_states{bot_num}(2)+x_add)*1000)>max_x
        max_x=round((curr_states{bot_num}(2)+x_add)*1000);
    end
    if round((curr_states{bot_num}(1)+y_add)*1000)>max_y
        max_y=round((curr_states{bot_num}(1)+y_add)*1000);
    end
    
    map=[round((obst(:,1)+x_add)*1000),round((obst(:,2)+y_add)*1000)];
    a1=max(round(max(map)));
    a2=max(max_x, max_y);
    costmap=zeros(max([a1;a2]));
    counter=counter+1;
%     if counter==1
    visit_costmap=zeros(max([a1;a2]));
%     end
    s=size(map);
    %Add obstacle cost
    for i=1:s(1)
        costmap(map(i,1),map(i,2))=costmap(map(i,1),map(i,2))+obstacle_cost;
    end
    %%%%%%%%%%%%%%%
    size(visit_costmap)
    round((curr_states{bot_num}(2)+x_add)*1000)
    round((curr_states{bot_num}(1)+y_add)*1000)
    
    if round((curr_states{bot_num}(2)+x_add)*1000)>0&&round((curr_states{bot_num}(1)+y_add)*1000)>0
     visit_costmap(round((curr_states{bot_num}(2)+x_add)*1000),round((curr_states{bot_num}(1)+y_add)*1000))=visit_costmap(round((curr_states{bot_num}(2)+x_add)*1000),round((curr_states{bot_num}(1)+y_add)*1000))+visitation_cost;
    end
     %Add visitation cost
% %     if counter==1
% %         visit_costmap=zeros(size(costmap));
% %     end
% %     visit_costmap(round((curr_states{i}(2)+x_add)*1000),round((curr_states{i}(1)+y_add)*1000))=visit_costmap(round((curr_states{i}(2)+x_add)*1000),round((curr_states{i}(1)+y_add)*1000))+visitation_cost;
    
% scatter(obst(:,1),obst(:,2),'b')
% scatter(map(:,1),map(:,2),'k')
hold on
% scatter(botx,boty,'r')
else map=[];
    %Add visitation cost
    costmap=[];
end

for i=1:num_bots
    botx(i)=(curr_states{i}(2)+x_add)*1000;
    boty(i)=(curr_states{i}(1)+y_add)*1000;
end
% scatter(curr_states{bot_num}(2),curr_states{bot_num}(1),'r')
%axis([-1.2 1.2 -1.2 1.2])
hold on



cmd=strcat('w',num2str(round(50)),';',num2str(round(50)),';',num2str(500),';');
bot.write(1,cmd);
%Global


%p control on heading
% % % ref=0;
% % % if abs(curr_states{bot_num}(3)-ref)>0.1
% % %     Kp=30;
% % %     du=Kp*(curr_states{bot_num}(3)-ref);
% % %     cmd=strcat('w',num2str(round(du)),';',num2str(round(-du)),';',num2str(300),';');
% % %     bot.write(1,cmd);
% % % end

end