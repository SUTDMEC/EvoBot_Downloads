function [EST,EST_robot_not_obstacle]=plotStateEst(ESTtime, ESTx,ESTy,ESTtheta,ESTthetaP2,GTtime,GTx,GTy,GTtheta,filename,inc,IRData,bot_data,num_bots,thet_con,pos)
%this function plots the estimated states for all of the run against the
%ground-truth for that run
%No need for the {i}{j} indices. Keep it for now, remove it later
try
    %show time-series displacement plots
    component_disp=1;
    %show error plots
    error_disp=0;
    
for i=1:length(ESTtime)
    for j=1:length(ESTtime{i})
    %first synchronize the times for that run. Sensor times are absolute,
    %where as Ground Truth tracking time is relative (counter) time
    %perform this tracking by synching the first time where motion is
    %detected via ground-truth. The robot only sends data while in motion,
    %hence the estimated time will always include motion
    
    %save file for video frame comparison
    
    %assuming that yaw is around the z-plane
    for k=1:length(ESTtheta{i}{j})
        R(k,:)=[cos(ESTtheta{i}{j}(k)), -sin(ESTtheta{i}{j}(k)),0, sin(ESTtheta{i}{j}(k)), cos(ESTtheta{i}{j}(k)),0, 0,0,1 ];
    end
%     dtime=diff(ESTtime{i}{j});
%     dtime=[0;dtime];
%     dx=diff(ESTx{i}{j});
%     dx=[0;dx];
%     dy=diff(ESTy{i}{j});
%     dy=[0;dy];
%     dz=zeros(length(ESTx{i}{j}),1);
%     posedata=[R,dx,dy,dz,dtime];
%     if ~exist(filename{i}{j},'dir')
%         mkdir(filename{i}{j});
%     end
% %     keyboard
% 
%     csvwrite(strcat(filename{i}{j},'coslaminput.csv'),posedata);
    
    idx_mot_gt=find(abs(diff(GTx{i}{j}))>0.0000); %find index where difference in perceived x is above .1 mm
    
    GTtime_scaled{i}{j}=GTtime{i}{j}(idx_mot_gt(1):end)-GTtime{i}{j}(idx_mot_gt(1));
    GTx_scaled{i}{j}=GTx{i}{j}(idx_mot_gt(1):end);
    GTy_scaled{i}{j}=GTy{i}{j}(idx_mot_gt(1):end);
    GTtheta_scaled{i}{j}=GTtheta{i}{j}(idx_mot_gt(1):end);
    
    idx_mot_est=find(abs(diff(ESTx{i}{j}))>0.0000); %find index where difference in perceived x is above .1 mm
    
    ESTtime_scaled{i}{j}=ESTtime{i}{j}(idx_mot_est(1):end)-ESTtime{i}{j}(idx_mot_est(1));
    ESTx_scaled{i}{j}=ESTx{i}{j}(idx_mot_est(1):end);
    ESTy_scaled{i}{j}=ESTy{i}{j}(idx_mot_est(1):end);
    ESTtheta_scaled{i}{j}=ESTtheta{i}{j}(idx_mot_est(1):end);
    ESTthetaP2_scaled{i}{j}=ESTthetaP2{i}{j}(idx_mot_est(1):end);
    
%     keyboard
    
    %synchronize data as time series objects
    gtx=timeseries(GTx_scaled{i}{j},GTtime_scaled{i}{j});
    gty=timeseries(GTy_scaled{i}{j},GTtime_scaled{i}{j});
    gttheta=timeseries(GTtheta_scaled{i}{j},GTtime_scaled{i}{j});
    
    if ~iscolumn(ESTx_scaled{i}{j}) %for optical flow estimates, occasionally
        ESTx_scaled{i}{j}=ESTx_scaled{i}{j}';
    end
    if ~iscolumn(ESTy_scaled{i}{j}) %for optical flow estimates, occasionally
        ESTy_scaled{i}{j}=ESTy_scaled{i}{j}';
    end
    if ~iscolumn(ESTthetaP2_scaled{i}{j}) %for optical flow estimates, occasionally
        ESTthetaP2_scaled{i}{j}=ESTthetaP2_scaled{i}{j}';
    end
    etx=timeseries(ESTx_scaled{i}{j},ESTtime_scaled{i}{j});
    ety=timeseries(ESTy_scaled{i}{j},ESTtime_scaled{i}{j});
    etheta=timeseries(rad2deg(ESTthetaP2_scaled{i}{j}),ESTtime_scaled{i}{j});
    
    [gtxs, etxs] = synchronize(gtx,etx, 'Union');
    [gtys, etys] = synchronize(gty,ety, 'Union');
    [gtts, etts] = synchronize(gttheta,etheta, 'Union');
%     keyboard
%     a_x{i}{j}=abs(gtxs.Data-etxs.Data);
%     a_y{i}{j}=abs(gtys.Data-etys.Data);
%     a_t{i}{j}=abs(gtts.Data-etts.Data);
    
    %calculated time-windowed error
    winsize=200; %number of samples to add at each step
    x_time=[];
    y_time=[];
    t_time=[];
    
% % % % % % % % % % % % % % % % % % % % % % % %     for tx=1:winsize:length(gtxs.Time)-winsize
% % % % % % % % % % % % % % % % % % % % % % % % %         r_x{i}{j}(tx)=rmse(getdatasamples(gtxs,tx:tx+winsize),getdatasamples(etxs,tx:tx+winsize)); %for rolling window
% % % % % % % % % % % % % % % % % % % % % % % %         r_x{i}{j}(tx)=rmse(getdatasamples(gtxs,1:tx+winsize),getdatasamples(etxs,1:tx+winsize)); %for growing window
% % % % % % % % % % % % % % % % % % % % % % % %         x_time(tx)=(gtxs.Time(tx)+gtxs.Time(tx+winsize))/2;
% % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % %     for ty=1:winsize:length(gtys.Time)-winsize
% % % % % % % % % % % % % % % % % % % % % % % % %         r_y{i}{j}(ty)=rmse(getdatasamples(gtys,ty:ty+winsize),getdatasamples(etys,ty:ty+winsize)); %for rolling window
% % % % % % % % % % % % % % % % % % % % % % % %         r_y{i}{j}(ty)=rmse(getdatasamples(gtys,1:ty+winsize),getdatasamples(etys,1:ty+winsize)); %for growing window
% % % % % % % % % % % % % % % % % % % % % % % %         y_time(ty)=(gtys.Time(ty)+gtys.Time(ty+winsize))/2;
% % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % %     for tt=1:winsize:length(gtts.Time)-winsize
% % % % % % % % % % % % % % % % % % % % % % % % %         r_t{i}{j}(tt)=rmse(getdatasamples(gtts,tt:tt+winsize),getdatasamples(etts,tt:tt+winsize)); %for rolling window
% % % % % % % % % % % % % % % % % % % % % % % %         r_t{i}{j}(tt)=rmse(getdatasamples(gtts,1:tt+winsize),getdatasamples(etts,1:tt+winsize)); %for growing window
% % % % % % % % % % % % % % % % % % % % % % % %         t_time(tt)=(gtts.Time(tt)+gtts.Time(tt+winsize))/2;
% % % % % % % % % % % % % % % % % % % % % % % %     end


%     if component_disp
%         %x displacement
%         %%%%%%%%%%%%%%Plots for x and y comparison. Commented out for now.
% % % % % % %         figure
% % % % % % %         %size(GTx_scaled)
% % % % % % %         plot(GTtime_scaled{i}{j},GTx_scaled{i}{j})
% % % % % % % %         plot(GTtime{i}{j},GTx{i}{j})
% % % % % % %         hold
% % % % % % %         plot(ESTtime_scaled{i}{j},ESTx_scaled{i}{j},'r')
% % % % % % %         title(strcat('Robot:',num2str(i*j)))
% % % % % % %         xlabel('Time')
% % % % % % %         ylabel('X position')
% % % % % % %         legend({'Capture','Estimate'})
% % % % % % % 
% % % % % % %         %y displacement
% % % % % % %         figure
% % % % % % %         plot(GTtime_scaled{i}{j},GTy_scaled{i}{j})
% % % % % % % %         plot(GTtime{i}{j},GTy{i}{j})
% % % % % % %         hold
% % % % % % %         plot(ESTtime_scaled{i}{j},ESTy_scaled{i}{j},'r')
% % % % % % %         title(strcat('Robot:',num2str(i*j)))
% % % % % % %         xlabel('Time')
% % % % % % %         ylabel('Y position')
% % % % % % %         legend({'Capture','Estimate'})
% 
% %         %Rotation Redundant
% %         figure
% %         plot(GTtime_scaled{i}{j},GTtheta_scaled{i}{j})
% % %         plot(GTtime{i}{j},GTtheta{i}{j})
% %         hold
% %         plot(ESTtime_scaled{i}{j},rad2deg(ESTthetaP2_scaled{i}{j}),'r')
% %         title(strcat('Run:',num2str(i*j)))
% %         xlabel('Time')
% %         ylabel('Theta rotation')
% %         legend({'Capture','Estimate'})
%     end

if length(GTx_scaled{i}{j})==length(ESTx_scaled{i}{j})
%         if strcmp(inc,'1')
            xpos=pos{str2num(inc)}(1);
            ypos=pos{str2num(inc)}(2);
            
% %         elseif strcmp(inc,'2')
% %             xpos=-0.4553;
% %             ypos=0.588;
% %         elseif strcmp(inc,'3')
% %             xpos=-0.2498;
% %             ypos=0.78118;
%         elseif strcmp(inc,'2')
%             xpos=-0.03254;
%             ypos=0.47033;
% %         elseif strcmp(inc,'5')
% %             xpos=0.2166;
% %             ypos=0.8105;
% %         elseif strcmp(inc,'8')
% %             xpos=0.4458;
% %             ypos=0.6256;
%         elseif strcmp(inc,'3')
%             xpos=0.69412;
%             ypos=0.82106;
%         end
        GTx{i}{j}(1)=-xpos;
        GTy{i}{j}(1)=-ypos;
        ESTy=ESTy_scaled;
        ESTx=ESTx_scaled;
if thet_con==0||thet_con==1%remove thet_con==1 to not have maps in theta consensus mode
        f=plot(-ESTy{i}{j}-GTx{i}{j}(1),ESTx{i}{j}+GTy{i}{j}(1),'b');
        axis([-1.2 1.2 -1.2 1.2])
        title(strcat('Robot:',inc))
        hold on
         xlabel('X position (m)')
        ylabel('Y position (m)')
        legend({'Estimate'})
end
    else
    
            % displacement
%         figure
% %         plot(GTx_scaled{i}{j},GTy_scaled{i}{j})
%         plot(GTy{i}{j},GTx{i}{j})
%         hold
%         plot(ESTx_scaled{i}{j},ESTy_scaled{i}{j},'r--')



    
        f=plot(-ESTy{i}{j}-GTx{i}{j}(1),ESTx{i}{j}+GTy{i}{j}(1),'b');
        axis([-1.2 1.2 -1.2 1.2])
        hold on
        plot(-GTx_scaled{i}{j},GTy_scaled{i}{j},'r')
        axis([-1.2 1.2 -1.2 1.2])
        %title(strcat('Robot:',inc))
        title('Environment map')
        xlabel('X position (m)')
        ylabel('Y position (m)')
        legend('Estimate','Ground Truth')
        %fprintf(['The final distance error is: ' num2str(((ESTx_scaled{i}{j}(end)+GTy{i}{j}(1)-GTy_scaled{i}{j}(end))^2 + (ESTy_scaled{i}{j}(end)+GTx{i}{j}(1)-GTx_scaled{i}{j}(end))^2)^0.5) ' m between the estimate and the ground truth \n']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Write coslaminput.csv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dtime=diff(ESTtime{i}{j});
    dtime=[0;dtime];
    dx=diff(-ESTy{i}{j}-GTx{i}{j}(1));
    dx=[0;dx];
    dy=diff(ESTx{i}{j}+GTy{i}{j}(1));
    dy=[0;dy];
    dz=zeros(length(ESTx{i}{j}),1);
    len=min([length(R);length(dx);length(dy);length(dz);length(dtime)]);
    posedata=[dtime(1:len,:),R(1:len,:),dx(1:len),dy(1:len),dz(1:len)];
    if ~exist(filename{i}{j},'dir')
        mkdir(filename{i}{j});
    end
%     keyboard

disp('Generating CoSLAM inputs...')
    csvwrite(strcat(filename{i}{j},'coslaminput.csv'),posedata);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obst_C=IRData{i}{j}.C;
    obst_L=IRData{i}{j}.L;
    obst_R=IRData{i}{j}.R;

    for k=1:len%length(IRData{i}{j}.C)
        obst_C_x(k)=(-ESTy{i}{j}((k))-GTx{i}{j}(1))+((IRData{i}{j}.C((k)))/1000)*sin(-ESTtheta{i}{j}((k)));%Plot obstacles
        obst_C_y(k)=ESTx{i}{j}((k))+GTy{i}{j}(1)+((IRData{i}{j}.C((k)))/1000)*cos(-ESTtheta{i}{j}((k)));
        obst_L_x(k)=(-ESTy{i}{j}((k))-GTx{i}{j}(1))+((IRData{i}{j}.L((k)))/1000)*sin((-72*pi/180)-ESTtheta{i}{j}((k)));
        obst_L_y(k)=ESTx{i}{j}((k))+GTy{i}{j}(1)+((IRData{i}{j}.L((k)))/1000)*cos((-72*pi/180)-ESTtheta{i}{j}((k)));
        obst_R_x(k)=(-ESTy{i}{j}((k))-GTx{i}{j}(1))+((IRData{i}{j}.R((k)))/1000)*sin((72*pi/180)-ESTtheta{i}{j}((k)));
        obst_R_y(k)=ESTx{i}{j}((k))+GTy{i}{j}(1)+((IRData{i}{j}.R((k)))/1000)*cos((72*pi/180)-ESTtheta{i}{j}((k)));
    end
    
    EST=[-ESTy{i}{j}-GTx{i}{j}(1) ESTx{i}{j}+GTy{i}{j}(1) obst_C_x' obst_C_y' obst_L_x' obst_L_y' obst_R_x' obst_R_y' ESTtime{i}];


    thresh=0.2;
  
    if str2num(inc)==num_bots %Check if all robots' data has been received
        bot_data{num_bots}=EST;
        for k=1:num_bots
            for n=1:num_bots%k:k+num_bots-1
%                 if n>num_bots%looping through all robots
%                     n=n-num_bots;
%                 end
                    minlength=min(length(bot_data{k}{1}),length(bot_data{n}{3}));
            for m=1:minlength
                %Set x and y coordinates of the Right, left and center IR
                %obstacles to 0 if it is in the radius of 0.2 around
                %another robot
                if bot_data{n}{3}(m)<bot_data{k}{1}(m)+thresh&&bot_data{n}{3}(m)>bot_data{k}{1}(m)-thresh&&bot_data{n}{4}(m)<bot_data{k}{2}(m)+thresh&&bot_data{n}{4}(m)>bot_data{k}{2}(m)-thresh
                   bot_data{n}{3}(m)=0;
                   bot_data{n}{4}(m)=0;            
                end
                if bot_data{n}{5}(m)<bot_data{k}{1}(m)+thresh&&bot_data{n}{5}(m)>bot_data{k}{1}(m)-thresh&&bot_data{n}{6}(m)<bot_data{k}{2}(m)+thresh&&bot_data{n}{6}(m)>bot_data{k}{2}(m)-thresh
                   bot_data{n}{5}(m)=0;
                   bot_data{n}{6}(m)=0;            
                end
                if bot_data{n}{7}(m)<bot_data{k}{1}(m)+thresh&&bot_data{n}{7}(m)>bot_data{k}{1}(m)-thresh&&bot_data{n}{8}(m)<bot_data{k}{2}(m)+thresh&&bot_data{n}{8}(m)>bot_data{k}{2}(m)-thresh
                   bot_data{n}{7}(m)=0;
                   bot_data{n}{8}(m)=0;            
                end
            end
            

            end

        end
        xes=[];
        yes=[];
        for p=1:num_bots%Scan for obtsacles only within 0.4m
            for l=1:length(bot_data{p}{1})
                if sqrt(((bot_data{p}{1}(l)-bot_data{p}{3}(l))^2)+((bot_data{p}{2}(l)-bot_data{p}{4}(l))^2))<0.4
                    if thet_con==0||thet_con==1%remove thet_con==1 to not have maps in theta consensus mode
                    scatter(bot_data{p}{3}(l),bot_data{p}{4}(l),'k','MarkerFaceColor','k')
                    xes=[xes;bot_data{p}{3}(l)];
                    yes=[yes;bot_data{p}{4}(l)];
                    hold on
                    end
                else bot_data{p}{3}(l)=10;
                    bot_data{p}{4}(l)=10;
                    
                end
                if sqrt(((bot_data{p}{1}(l)-bot_data{p}{5}(l))^2)+((bot_data{p}{2}(l)-bot_data{p}{6}(l))^2))<0.4
                    if thet_con==0||thet_con==1%remove thet_con==1 to not have maps in theta consensus mode
                    scatter(bot_data{p}{5}(l),bot_data{p}{6}(l),'k','MarkerFaceColor','k')
                    xes=[xes;bot_data{p}{5}(l)];
                    yes=[yes;bot_data{p}{6}(l)];
                    hold on
                    end
                else
                    bot_data{p}{5}(l)=10;
                    bot_data{p}{6}(l)=10;                 
                end
                if sqrt(((bot_data{p}{1}(l)-bot_data{p}{7}(l))^2)+((bot_data{p}{2}(l)-bot_data{p}{8}(l))^2))<0.4
                    if thet_con==0||thet_con==1%remove thet_con==1 to not have maps in theta consensus mode
                    scatter(bot_data{p}{7}(l),bot_data{p}{8}(l),'k','MarkerFaceColor','k')
                    xes=[xes;bot_data{p}{7}(l)];
                    yes=[yes;bot_data{p}{8}(l)];
                    hold on
                    end
                else
                    bot_data{p}{5}(l)=10;
                    bot_data{p}{6}(l)=10;
                end
 
            end
            if p==1 
            save 1_data_scatter 'xes' 'yes';
            elseif p==2 
            save 2_data_scatter 'xes' 'yes';
            elseif p==3
            save 3_data_scatter 'xes' 'yes';
            elseif p==4
            save 4_data_scatter 'xes' 'yes';
            elseif p==5
            save 5_data_scatter 'xes' 'yes';
            elseif p==6
            save 6_data_scatter 'xes' 'yes';
            elseif p==7
            save 7_data_scatter 'xes' 'yes';
            end
            xes=[];
            yes=[];
        end
%            figure
%     scatter(xes,yes);
%     save 'data_scatter_all' 'xes' 'yes';
    end

    
    EST_robot_not_obstacle=bot_data;
    

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%Plot obstacles- Stitch maps of all robots together%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for k=1:length(IRData{i}{j}.C)        %Find the IR readings which correspond to obstacles in the range of 25-40cm. Do this for L,R and C
% %     obst_C1=find(IRData{i}{j}.C>250);
% %     obst_C2=find(IRData{i}{j}.C<400);
% %     obst_C=intersect(obst_C1,obst_C2);
% %     obst_L1=find(IRData{i}{j}.L>250);
% %     obst_L2=find(IRData{i}{j}.L<400);
% %     obst_L=intersect(obst_L1,obst_L2);
% %     obst_R1=find(IRData{i}{j}.R>250);
% %     obst_R2=find(IRData{i}{j}.R<400);
% %     obst_R=intersect(obst_R1,obst_R2);
% % end
% % 
% % if numel(obst_C)>1%If any obstacles are found by the center IR
% % for k=1:length(obst_C)-1
% %     
% %     if (obst_C(k))<=length(ESTtheta_scaled{i}{j})
% % 
% %     obst_C_x=(-ESTy{i}{j}(obst_C(k))-GTx{i}{j}(1))+((IRData{i}{j}.C(obst_C(k)))/1000)*sin(-ESTtheta_scaled{i}{j}(obst_C(k)));%Plot obstacles
% %     obst_C_y=ESTx{i}{j}(obst_C(k))+GTy{i}{j}(1)+((IRData{i}{j}.C(obst_C(k)))/1000)*cos(-ESTtheta_scaled{i}{j}(obst_C(k)));
% %     
% %     scatter(obst_C_x,obst_C_y,'k')
% %     hold on
% %     end
% % end
% % end
% % if numel(obst_L)>1%If any obstacle found by left IR
% % for k=1:length(obst_L)-1
% %     if (obst_L(k))<=length(ESTtheta_scaled{i}{j})
% % %Plot obstacles
% %     obst_L_x=(-ESTy{i}{j}(obst_L(k))-GTx{i}{j}(1))+((IRData{i}{j}.L(obst_L(k)))/1000)*sin((-72*pi/180)-ESTtheta_scaled{i}{j}(obst_L(k)));
% %     obst_L_y=ESTx{i}{j}(obst_L(k))+GTy{i}{j}(1)+((IRData{i}{j}.L(obst_L(k)))/1000)*cos((-72*pi/180)-ESTtheta_scaled{i}{j}(obst_L(k)));
% %     scatter(obst_L_x,obst_L_y,'k')
% %     hold on
% %     end
% % end
% % end
% % 
% % if numel(obst_R)>1%If any obstacle found by left IR
% % for k=1:length(obst_R)-1
% %     if (obst_R(k))<=length(ESTtheta_scaled{i}{j})
% % %Plot obstacles
% %     obst_R_x=(-ESTy{i}{j}(obst_R(k))-GTx{i}{j}(1))+((IRData{i}{j}.R(obst_R(k)))/1000)*sin((72*pi/180)-ESTtheta_scaled{i}{j}(obst_R(k)));
% %     obst_R_y=ESTx{i}{j}(obst_R(k))+GTy{i}{j}(1)+((IRData{i}{j}.R(obst_R(k)))/1000)*cos((72*pi/180)-ESTtheta_scaled{i}{j}(obst_R(k)));
% %     scatter(obst_R_x,obst_R_y,'k')
% %     hold on
% %     end
% % end
% % end



        %Absolute error
        if error_disp
            figure
            plot(gtxs.Time,a_x{i}{j},'k')
            hold
            plot(gtys.Time,a_y{i}{j},'g')
            plot(gtts.Time,a_t{i}{j},'c')
            ylabel('Absolute error')
            xlabel('Time')
            legend({'x-coordinate' 'y-coordinate' 'theta'})

            %time-windowed root-mean squared error
            figure
            plot(x_time,r_x{i}{j},'ks')
            hold
            plot(y_time,r_y{i}{j},'gs')
            plot(t_time,r_t{i}{j},'cs')
            ylabel('RMS error over time window')
            xlabel('Time')
            title(strcat('Error averaging window: ',num2str(winsize)));
            legend({'x-coordinate' 'y-coordinate' 'theta'})
        end
    end
    
end
%         keyboard

if str2num(inc)==num_bots
    if thet_con==0||thet_con==1%remove thet_con==1 to not have maps in theta consensus mode
saveas(f,'EnvironmentMap','tif')
img=imread('EnvironmentMap.tif');
imgfilt=medfilt2(img(:,:,1),[15 15]);
figure
colormap(gray)
image(imgfilt)
title('Environment Map')
    end
end

catch
    a=lasterror
    keyboard
end