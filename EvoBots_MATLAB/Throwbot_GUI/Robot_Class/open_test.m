function [open_points]=open_test(points,open_map)
open_points=[];
for i=1:length(points)
    neigh=neighbours(open_map,points(i,:));
    for j=1:length(neigh)
        if open_map(neigh(j,:))==0
            open_points=[open_points;points(i,:)];
        end
    end
end