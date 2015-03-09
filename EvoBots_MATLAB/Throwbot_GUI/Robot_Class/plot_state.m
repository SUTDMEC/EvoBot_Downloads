clear all
close all
load state_hist
s=size(state_hist);
bot_num=min(s(1),s(2));

for i=1:bot_num
    bot{i}=mat2cell(state_hist(:,i));
    robot{i}=bot{i}{1}(~cellfun('isempty',bot{i}{1}));
    for j=1:length(robot{i})
        pos(j,:)=[robot{i}{j}]; 
    end
        figure
        plot(pos(:,3))
        title(strcat('Robot ',num2str(i),' estimated heading'))
        figure
        plot(pos(:,1),pos(:,2))
        title(strcat('Robot ',num2str(i),' estimated path'))
        figure
        plot(pos(:,4))
        hold on
        plot(pos(:,5),'r')
        title(strcat('Robot ',num2str(i),' velocity estimate'))
end