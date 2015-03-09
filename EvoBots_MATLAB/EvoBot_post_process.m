basedir='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\long run\';
% filename='Take 2014-04-23 08.41.11 AM.xlsx'; % 50 second rotation
% filename='Take 2014-04-23 08.43.36 AM.xlsx'; % x 5 second rotations
% filename='Take 2014-04-23 08.57.53 AM.xlsx'; %2,4,6,8 second rotations

filename='Take 2014-04-24 09.33.38 PM.xlsx'; %golden run 1

in.moviefile=strcat(basedir,'test3.avi');


raw=importdata(strcat(basedir,filename));

idx=find(ismember(raw.textdata.Take(:,1),'frame'));

GTtime=raw.data.Take(idx,2);
GTx=raw.data.Take(idx,5); %our x
GTz=raw.data.Take(idx,6); %our z
GTy=raw.data.Take(idx,7); %our y

GTroll=raw.data.Take(idx,12); %in degrees
GTpitch=raw.data.Take(idx,13); %in degrees
GTyaw=raw.data.Take(idx,14); %in degrees

figure
plot(GTtime,GTroll);

figure
plot(GTx,GTz,'*')

GTtheta=GTroll;

matfilename='all_data14_04_24_21_54.mat';
load(strcat(basedir,matfilename));

ind=1;
for i=1:length(in.data)
    if isfield(in.data{i},'sens_data')
        Ptime=in.data{i}.sens_time;
        Pcurrent(ind)=in.data{i}.sens_data{1}/1000; %in A
        Pvoltage(ind)=in.data{i}.sens_data{2}; %in V
        Ppower(ind)=Pcurrent(ind)*Pvoltage(ind);
        ind=ind+1;
    end
    
end

BOTtime=[];
BOTx=[];
BOTy=[];
BOTtheta=[];
for j=1:length(in.state)
    BOTtime=[BOTtime;in.state{j}.previous_sync_time];
    BOTx=[BOTx;in.state{j}.x'];
    BOTy=[BOTy;in.state{j}.y'];
    BOTtheta=[BOTtheta;in.state{j}.theta'];
end

x_walls=[];
y_walls=[];
figure
hold

for k=1:length(in.map_out)
    x_wall=in.map_out{k}.landmark_x_location';
    y_wall=in.map_out{k}.landmark_y_location';
    plot(x_wall,y_wall,'k*')
    x_walls=[x_walls;x_wall];
    y_wall=[y_walls;y_wall];
end


%adjust groundtruth
plot(BOTx,BOTy)
scaledGTx=GTx*100;
scaledGTy=-GTy*100;
x_offset=BOTx(1)-scaledGTx(1);
y_offset=BOTy(1)-scaledGTy(1);

plot(scaledGTx+x_offset,scaledGTy+y_offset,'r')
xlabel('x Position (cm)')
ylabel('y Position (cm)')


grid on
in.GTx=GTx;
in.GTy=GTy;
in.BOTx=BOTx;
in.BOTy=BOTy;
% 
% 
% figure
% plot(Ptime,Ppower)



% figure
% plot(BOTtime,BOTtheta,'*');
% hold
% plot(GTtime,GTtheta,'*r');
% 
% in.x=GTx*100;
% in.y=GTy*100;
% in.theta=GTtheta;
% in.skip_val=100;

% plotTraj_stepwise(in)

