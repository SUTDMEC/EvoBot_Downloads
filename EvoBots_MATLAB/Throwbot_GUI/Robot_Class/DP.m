function [path,value]=DP(map,goal,start)
tic
path=[];
cost_step=1;
value=99*ones(size(map));
change=1;
 while change==1
     change=0;
     s=size(map);
     for i=1:s(1)
         for j=1:s(2)
             if i==goal(1)&&j==goal(2)
                 if value(i,j)>0
                     value(i,j)=0;
                     change=1;
                 end
             
             
             elseif map(i,j)==0
                 neigh=neighbours(map,[i,j]);
                 s_n=size(neigh);
                 for k=1:s_n(1)
                     v2=value(neigh(k,1),neigh(k,2))+cost_step;
                     if v2<value(i,j)
                         change=1;
                         value(i,j)=v2;
                     end
                 end
             end
         end
     end
 end
toc
tic
while start(1)~=goal(1)&&start(2)~=goal(2) 
    neigh=neighbours(value,start);
    s=size(neigh);
    for i=1:s(1)
        v(i)=value(neigh(i,1),neigh(i,2));
        f=find(min(v)==v);
        path=[path; neigh(f(1),:)];
    end
    s_p=size(path);
    start=path(s_p(1),:);
end
 toc