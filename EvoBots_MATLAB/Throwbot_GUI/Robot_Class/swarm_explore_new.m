function [obs_map,map,obst,visited_pts,fin_map,angle_reached,prev_theta,resolution,min_x,min_y,path_log,angle_changed,mov_theta]=swarm_explore_new(bot,curr_states,state_hist,bot_num,obst,num_bots,visited_pts,angle_reached,prev_theta,target_bot,target_pos,angle_changed)

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
flag=0;
obstacle_cost=1000;
visitation_cost=0.24*obstacle_cost;
resolution=1/10;%Map Resolution: From mm to cm; 1/1000: From mm to m
min_x=0;
min_y=0;
path=[];
mov_theta=zeros(1,num_bots);
path_log={};
%%%%%%%%%%%%%%%%%%%%%%%%Get all IR points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ir_pos=1:3
    
if IR(ir_pos)<=320&&IR(ir_pos)~=-1
    if ir_pos==2
        obs_C_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos((curr_states{bot_num}(3)));
        obs_C_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin((curr_states{bot_num}(3)));        
        if obs_C_x~=0||obs_C_y~=0
            obs_C=[obs_C_y,obs_C_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_C_x),round(curr_states{bot_num}(2)+obs_C_y))=obstacle_cost;
    elseif ir_pos==1
        obs_L_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos(((72*pi/180)+curr_states{bot_num}(3)));
        obs_L_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin(((72*pi/180)+curr_states{bot_num}(3)));
        if obs_L_x~=0||obs_L_y~=0
            obs_L=[obs_L_y,obs_L_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_L_x),round(curr_states{bot_num}(2)+obs_L_y))=obstacle_cost;
    elseif ir_pos==3
        obs_R_x=curr_states{bot_num}(1)+((IR(ir_pos))/1000)*cos(((-72*pi/180)+curr_states{bot_num}(3)));
        obs_R_y=curr_states{bot_num}(2)+((IR(ir_pos))/1000)*sin(((-72*pi/180)+curr_states{bot_num}(3)));
        if obs_R_x~=0||obs_R_y~=0
            obs_R=[obs_R_y,obs_R_x];
        end
%         map(round(curr_states{bot_num}(1)+obs_R_x),round(curr_states{bot_num}(2)+obs_R_y))=obstacle_cost;
    end
end

end

obst=[obst;obs_C;obs_L;obs_R];%Contains left, right and center IR obstacle coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Forming obstacle costs
if length(obst)>1
     map=[round((obst(:,1))*1000),round((obst(:,2))*1000) obstacle_cost*ones(length(obst(:,1)),1)];
else map=[];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Current point%
curr=[round(1000*curr_states{bot_num}(2)) round(1000*curr_states{bot_num}(1)) visitation_cost];
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%Including visitation costs to the map%%%%%%%%%%%%%%%
if length(visited_pts)>0
c2=find(curr(2)==visited_pts(:,2));
if length(c2)>0
    for i=1:length(c2)
        if visited_pts(c2(i),1)==curr(1)&&visited_pts(c2(i),2)==curr(2)
            flag=1;
            visited_pts(c2(i),3)=visited_pts(c2(i),3)+visitation_cost;
        end
    end
else visited_pts=[visited_pts;curr];
end
else visited_pts=[visited_pts;curr];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%Make usable map%%%%%%%%%%%%%%%%%%%%%
if length(map)>0
    map1=map(:,1);
    map2=map(:,2);
    map3=map(:,3);
else map1=[];
    map2=[];
    map3=[];
end

% scatter(map2,map1,'k')
% hold on
% scatter(curr(:,2),curr(:,1),'b')
% hold on

%All map points - obstacles and visited paths included
map_x=round([map1;visited_pts(:,1)]*resolution);
map_y=round([map2;visited_pts(:,2)]*resolution);
map_cost=round([map3;visited_pts(:,3)]*resolution);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obstacle map points only
obs_x=round(map1*resolution);
obs_y=round(map2*resolution);
obs_cost=round(map3*resolution);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Getting rid of 0 and negative indices
for ii=1:num_bots
    pt_raw(ii,:)=round([(resolution*1000*curr_states{ii}(2)) (resolution*1000*curr_states{ii}(1))]);
%     pt_resolution(ii,:)=[round(pt_raw(1)*resolution)+abs(min_x)+2 ,round(pt_raw(2)*resolution)+abs(min_y)+2];
end


min_x=min([map_x;pt_raw(:,1)]);
min_y=min([map_y;pt_raw(:,2)]);

map_x_f=map_x+abs(min_x)+2;
map_y_f=map_y+abs(min_y)+2;

obs_x_f=obs_x+abs(min_x)+2;
obs_y_f=obs_y+abs(min_y)+2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Forming obstacle and complete map%%%%%%%%

% pt_resolution(1,:)
% pt_resolution(2,:)

max_x=max([map_x;pt_raw(:,1)]);
max_y=max([map_y ;pt_raw(:,2)]);

obs_map=zeros(max_x,max_y);
fin_map=zeros(max_x,max_y);

for i=1:length(map_x_f)
    fin_map(map_x_f(i),map_y_f(i))=map_cost(i);
end

for i=1:length(obs_x_f)
    obs_map(obs_x_f(i),obs_y_f(i))=obs_cost(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Current map position%%%%%%%%%%%%%%%%%%%%%%%%
map_pos=[round((curr(:,1)*resolution))+abs(min_x)+2 round(curr(:,2)*resolution)+abs(min_y)+2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%
% st_pt_raw=[round(1000*curr_states{1}(2)) round(1000*curr_states{1}(1))];
% st_1=[round(st_pt_raw(1)*resolution)+abs(min_x)+2 ,round(st_pt_raw(2)*resolution)+abs(min_y)+2]
% st_pt_raw=[round(1000*curr_states{2}(2)) round(1000*curr_states{2}(1))];
% st_2=[round(st_pt_raw(1)*resolution)+abs(min_x)+2 ,round(st_pt_raw(2)*resolution)+abs(min_y)+2]
% 
% if length(obs_x_f)>0
%         scatter(obs_y_f,obs_x_f,'k')
% %         disp('plotted')
% %         axis([-1200 1200 -1200 1200])
% end
% 
% hold on
% scatter(st_1(2),st_1(1),'r')
% hold on
% scatter(st_2(2),st_2(1),'b')
% hold on

%%%%%%%%%%%%%%%%%%
% load fake_map
% 
% obs_map=fake_map;
if target_bot>0
    
    N=5;
    se=ones(2*N+1,2*N+1);
    G=imdilate(obs_map,se);
%     size(G)
st_pt_raw=[round(1000*curr_states{1}(2)) round(1000*curr_states{1}(1))];
st_1=[round(st_pt_raw(1)*resolution)+abs(min_x)+2 ,round(st_pt_raw(2)*resolution)+abs(min_y)+2];
st_pt_raw=[round(1000*curr_states{2}(2)) round(1000*curr_states{2}(1))];
st_2=[round(st_pt_raw(1)*resolution)+abs(min_x)+2 ,round(st_pt_raw(2)*resolution)+abs(min_y)+2];

    target_pt_raw=[round(1000*target_pos(1)) round(1000*target_pos(2))];
    target_pt_resolution=[round(target_pt_raw(1)*resolution)+abs(min_x)+2 ,round(target_pt_raw(2)*resolution)+abs(min_y)+2];
    Gsize=size(G);
    if target_pt_resolution(1)>Gsize(1)||target_pt_resolution(2)>Gsize(2)
        G(target_pt_resolution(1),target_pt_resolution(2))=0;
    end
    
    while G(target_pt_resolution(1),target_pt_resolution(2))>0
        Gsize=size(G);
        if Gsize(1)>0&&Gsize(2)>0
        N=N-1;
        if N>=1
        se=ones(2*N+1,2*N+1);
        G=imdilate(obs_map,se);
        else
            break
        end
        else break
        end
    end
    for ii=1:num_bots
        st_pt_raw=[round(1000*curr_states{ii}(2)) round(1000*curr_states{ii}(1))];
        st_pt_resolution{ii}=[round(st_pt_raw(1)*resolution)+abs(min_x)+2 ,round(st_pt_raw(2)*resolution)+abs(min_y)+2];
        if ~isequal(target_pt_resolution,st_pt_resolution{ii})
            target_pt_resolution
%             st_pt_resolution{ii}
                if length(obs_x_f)>0
                    scatter(obs_y_f,obs_x_f,'k')
                end
                
                st_pt_resolution{ii}
%                 if target_pt_resolution(1)>Gsize(1)
%                     target_pt_resolution(1)=Gsize(1);
%                 end
%                 if target_pt_resolution(2)>Gsize(2)
%                     target_pt_resolution(2)=Gsize(2);
%                 end
%                 if st_pt_resolution{ii}(1)>Gsize(1)
%                     st_pt_resolution{ii}(1)=Gsize(1);
%                 end
%                 if st_pt_resolution{ii}(2)>Gsize(2)
%                     st_pt_resolution{ii}(2)=Gsize(2);
%                 end
                    if target_pt_resolution(1)>Gsize(1)||target_pt_resolution(2)>Gsize(2)
                        G(target_pt_resolution(1),target_pt_resolution(2))=0;
                        obs_map(target_pt_resolution(1),target_pt_resolution(2))=0;
                    end
                     if st_pt_resolution{ii}(1)>Gsize(1)||st_pt_resolution{ii}(2)>Gsize(2)
                        G(st_pt_resolution{ii}(1),st_pt_resolution{ii}(2))=0;
                        obs_map(st_pt_resolution{ii}(1),st_pt_resolution{ii}(2))=0;
                    end
                    
            [path,cm]=Astar(G,target_pt_resolution,st_pt_resolution{ii});
%             pause
        else path=[];
        end
        
        path_log{ii}=path;
    end
    %%%%%%%%%%%%%%%%%%%%%%%path following%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
else


if angle_changed==0;
if rand>1
    angle_changed=1;
end

% angle_changed=0;
for i=1:3
    if IR(i)==-1
        IR(i)=2000;
    end
end
if angle_changed==0||IR(2)<=400%&&isequal(angle_reached,ones(1,num_bots))
    if IR(2)<=300
        if IR(1)<IR(3)
              %Turn right
                cmd=strcat('w',num2str(round(150)),';',num2str(round(-150)),';',num2str(500),';');
                bot.write(1,cmd);
        elseif IR(1)>IR(3)
            %Turn left
            cmd=strcat('w',num2str(round(-150)),';',num2str(round(150)),';',num2str(500),';');
                bot.write(1,cmd);
        elseif IR(1)==IR(3)
            if rand>0.5
                cmd=strcat('w',num2str(round(150)),';',num2str(round(-150)),';',num2str(500),';');
                bot.write(1,cmd);
            else
                cmd=strcat('w',num2str(round(-150)),';',num2str(round(150)),';',num2str(500),';');
                bot.write(1,cmd);
            end
            %Turn randomly
        end
    elseif IR(1)<250
        cmd=strcat('w',num2str(round(70)),';',num2str(round(30)),';',num2str(300),';');
        bot.write(1,cmd);
    elseif IR(3)<250
        cmd=strcat('w',num2str(round(30)),';',num2str(round(70)),';',num2str(300),';');
        bot.write(1,cmd);
    else
        cmd=strcat('w',num2str(round(50)),';',num2str(round(50)),';',num2str(300),';');
        bot.write(1,cmd);
    end    
angle_changed=0;
else
%%%%%%%%%%%%%%%%local and global cost based decision%%%%%%%%%%%%%%%%%%%%%%%
[mov_theta]=decisions(map_pos,fin_map,map_x_f,map_y_f,map_cost,resolution,num_bots);
angle_changed=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%Motion Control%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if angle_reached(bot_num)==1
%     ref(bot_num)=mov_theta(bot_num);
% else ref(bot_num)=prev_theta(bot_num);
% end

%%%%%%%%%%%%%%%%%%%%%%%%P control on heading%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if abs(curr_states{bot_num}(3)-ref(bot_num))>0.1
%     u_base=50;
%     Kp=30;
%     du=Kp*(curr_states{bot_num}(3)-ref(bot_num));
%     cmd=strcat('w',num2str(round(du+u_base)),';',num2str(round(-du+u_base)),';',num2str(300),';');
% % cmd=strcat('w',num2str(round(50)),';',num2str(round(50)),';',num2str(300),';');
%     bot.write(1,cmd);
%     angle_reached(bot_num)=0;
% else u_base=100;
%     angle_reached(bot_num)=1;
%     prev_theta=mov_theta;
%     cmd=strcat('w',num2str(round(u_base)),';',num2str(round(u_base)),';',num2str(300),';');
% % cmd=strcat('w',num2str(round(50)),';',num2str(round(50)),';',num2str(300),';');
% bot.write(1,cmd);
% end

end
end
end
    
end
