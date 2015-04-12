function [surround]=neighbours(map,point)
surround=[];
s=size(map);
for i=(point(1)-1):(point(1)+1)
    for j=(point(2)-1):(point(2)+1)
        if i>0&&i<=s(1)&&j>0&&j<=s(2)
            if i==point(1)&&j==point(2)
                surround=surround;
            else
                surround=[surround;[i j]];
            end
        end
    end
end