function [pt_log,closed_map,unfilt_path]=Astar(map,goal,start)

orig_map=map;
%%%%%Adding the heuristic function-euclidean distance from goal%%%%%%%
s_map=size(map);
maxmap=max(max(map));
for i=1:s_map(1)
    for j=1:s_map(2)
        mapcost(i,j)=(maxmap)*norm([goal]-[i j]);
    end
end
map=map+mapcost;

cost=1;
closed_map=zeros(size(map));
gvalue=1;
open=[gvalue start];
closed_map(open(1),open(2))=1;
ind=0;
found=0;
resign=0;
ii=1;
% for ii=1:100
while found==0&&resign==0

if length(open)==0
    resign=1;
    disp('Resigned')
    break
else
    s=size(open);
    tot_cost=[];
    for i=1:s(1)
%         if open(i,2)<=smap(1)&&open(i,3)<=smap(2)
smap=size(map);
if  open(i,2)>=smap(1)||open(i,3)>=smap(2)
    map(open(i,2),open(i,3))=0;
    orig_map(open(i,2),open(i,3))=0;
end
            tot_cost(i)=open(i,1)+map(open(i,2),open(i,3));
%         else tot_cost(i)=0;
%         end
    end
    f=find(min(tot_cost)==tot_cost);
    next=open(f(1),:);
    closed_map(next(2),next(3))=1;
    
    path(ii,:)=next;
    if next(2)==goal(1)&&next(3)==goal(2)
        found=1;
    else

        neigh=[];
        [neigh]=neighbours(map,[next(2) next(3)]);
        s_n=size(neigh);
        neigh_filt=zeros(s_n);
        for i=1:s_n(1)
                if orig_map(neigh(i,1),neigh(i,2))>0
                    neigh_filt(i,:)=[0 0];
                else neigh_filt(i,:)=neigh(i,:);
                end
        end
        neigh=neigh_filt;
        
        s_o=size(open);
        if s_o(1)>0
        for i=1:s_o(1)
            curr_open=open(i,:);
            if curr_open(2)==next(2)&&curr_open(3)==next(3)
                ind=i;
            end
        end
        end
        
        if ind>0
            open(ind,:)=[];
        end            
        
        s=size(neigh);
        gvalue=gvalue+cost;
        
        for i=1:s(1)
            if neigh(i,1)>0&&neigh(i,1)<=smap(1)&&neigh(i,2)>0&&neigh(i,2)<=smap(2)&&closed_map(neigh(i,1),neigh(i,2))==0             
                open=[open;[gvalue neigh(i,:)]];    
                closed_map(neigh(i,1),neigh(i,2))=1;
            end
        end
%             closed_map
    end

end
ii=ii+1;
end

mappt=[];

for i=1:s_map(1)
    for j=1:s_map(2)
        if orig_map(i,j)>0
            mappt=[mappt;[i j]];
        end
    end
end
if length(mappt)>0
figure
scatter(mappt(:,2),mappt(:,1),'k')
hold on
end
unfilt_path=path;

%%%%%%%%%%%%%%%%%%%%Filter paths%%%%%%%%%%%%%%%%
if resign~=1
pt=goal;
mod_path=[path(:,2) path(:,3)];
path=mod_path;
path=unique(path,'rows');
new_neigh=[];
pt_log=[pt];

while pt(1)~=start(1)||pt(2)~=start(2)
    %Find neighbours which are part of the path
    neigh=neighbours(map,pt);
    %filter neighbours so that only the ones that are part of the path are
    %returned
    s_n=size(neigh);
    s_path=size(path);
    new_neigh=[];
    for i=1:s_n(1)
        cnt=0;
        for j=1:s_path(1)
            if isequal([neigh(i,1) neigh(i,2)],[path(j,1) path(j,2)])
                cnt=cnt+1;
            end
        end
        if cnt>0
            new_neigh=[new_neigh;neigh(i,:)];
        end
    end
    
    %Remove pt from the path
    for i=1:s_path
        if isequal(pt,[path(i,1) path(i,2)])
            path(i,:)=[];
            break
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Find which new neighbour is closest to the starting point
    s_nn=size(new_neigh);
    d=[];
    for i=1:s_nn(1)
        d(i)=norm([new_neigh(i,1) new_neigh(i,2)]-[start(1) start(2)]);
    end
    if length(d)>0
        f=find(min(d)==d);
      if s_nn(1)>=f(1)
        pt=new_neigh(f(1),:);
      else
        pt=new_neigh(1,:);
      end
    end
    pt_log=[pt_log;pt];
end


else pt_log=[path(:,2) path(:,3)];
    
end
if length(pt_log)>0
% pt_log=sortrows(pt_log);
% scatter(pt_log(:,1),pt_log(:,2))
plot(smooth(pt_log(:,2)),smooth(pt_log(:,1)))
end

if resign==1
    pt_log=[];
    nomap=map;
    save nomap nomap
end
