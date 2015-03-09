basedir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\Golden_run_2\';
moviefile=strcat(basedir,'powervid2.avi');

matfilename='all_data14_04_24_16_26.mat';
load(strcat(basedir,matfilename));
%calculates the power consumption for a run
idx=1;
for j=1:length(in.sense_data)
    for i=1:length(in.sense_data{j})
        if isfield(in.sense_data{j}{i},'sens_data')
            time(idx)=in.sense_data{j}{i}.sens_time;
            current(idx)=in.sense_data{j}{i}.sens_data{1}/1000; %in A
            voltage(idx)=in.sense_data{j}{i}.sens_data{2}; %in V
            power(idx)=current(idx)*voltage(idx);
        end
        idx=idx+1;
    end
end

h1=figure;
writerObj = VideoWriter(moviefile);
open(writerObj);
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');

hold
grid on
xlabel('Time')
ylabel('Power (W)')

% xlim([0 1000])
ylim([0 4])

%remove zero times
idx=find(time==0);
time(idx)=[];
power(idx)=[];

[time,id]=sort(time);
power=power(id);

for k=1:20:length(power)
    plot(time(1:k),power(1:k),'r');
    datetick('x','keeplimits')

    frame = getframe(h1);
    writeVideo(writerObj,frame);
    pause(0.05);
end

close(writerObj);
