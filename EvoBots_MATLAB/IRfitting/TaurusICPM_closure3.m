

dbstop error; clear variables; close all;
disp('=============Fitting walls=================');

% create model

% out = plotRandomWalls(10,0.1,5,1);
% out = plotArena(0.5,10, 25,1,1);

% load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\Test_Mat_files\Test_Mat_files\test_365.mat')

% load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\Test_Mat_files\Test_Mat_files\test_366.mat')

% load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\IR_mapping\422_test.mat')
% load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\IR_mapping\424_test.mat')
% load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\IR_mapping\425_test.mat')
load('C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\IR_mapping\429_test.mat')


out.x=[];
out.y=[];

%unfiltered
% for i=1:length(bot_data)
%     out.x=[out.x;bot_data{i}{:,3};bot_data{i}{:,5};bot_data{i}{:,7}];
%     out.y=[out.y;bot_data{i}{:,4};bot_data{i}{:,6};bot_data{i}{:,8}];
% end


for i=1:length(EST_robot_not_obstacle)
    out.x=[out.x;EST_robot_not_obstacle{i}{:,3};EST_robot_not_obstacle{i}{:,5};EST_robot_not_obstacle{i}{:,7}];
    out.y=[out.y;EST_robot_not_obstacle{i}{:,4};EST_robot_not_obstacle{i}{:,6};EST_robot_not_obstacle{i}{:,8}];
end


plot(out.x,out.y,'*k')

keyboard

%check with Thommen - scaling factor x200 to cm?
M(1,:)=(out.x').*1000;
M(2,:)=(out.y').*1000;

%set up the first box to enclose the entire arena

out_wall = createTemplate(length(out.x), 50, 1, 200, 200); %inputs in cm, outputs in mm

T(1,:)=out_wall.xm.*1000./100;
T(2,:)=out_wall.ym.*1000./100;

GoF=[];
iterating =1;
idx=1;
in.model=[];

max_iter=10;

tic

%define the number of obstacles in the environment

size_obst=[26,22; 27,6; 14,9; 45,34; 13,26  ]; %in cm
% box sizes: 
% top of the L: 26x22
% big side of L: 27x6
% little bottom of L: 14x9
% big corner box: 45x34
% two box island: 13 x 26 and 13x21


obst_iter=30; %iterations to wait for the obstacles to fit

while iterating %iterate on the model form in order to shape the walls
    % fit template to model
    % - init with identity transformation (eye(3))
    % - no outlier rejection step (-1)
    % - use point-to-plane fitting
    
%     out=modelGen(in);
%     T=out.model;
    
    Tr_fit = icpMex(M,T,eye(3),-1,'point_to_plane');
    T_fit  = Tr_fit(1:2,1:2)*T + Tr_fit(1:2,3)*ones(1,size(T,2));

    %calculatee the goodness of fit
    GoF=sumsqr(T_fit-M);
    disp('Goodness-of-fit sse')
    disp(GoF);
    idx=idx+1;
    if idx==max_iter || GoF<500
        iterating=0;
    end

end



for i=1:length(size_obst) %iterate on the model form in order to shape the obstacles
    out2 = createTemplate(length(out.x), 50, 1, size_obst(i,1), size_obst(i,2)); %inputs in cm, outputs in mm
    T(1,:)=out2.xm.*1000./100;
    T(2,:)=out2.ym.*1000./100;

    Tr_fit = icpMex(M,T,eye(3),-1,'point_to_plane');
    T_fit_obs{i}  = Tr_fit(1:2,1:2)*T + Tr_fit(1:2,3)*ones(1,size(T,2));

    %calculatee the goodness of fit
    GoF(i)=sumsqr(T_fit_obs{i}-M);
    disp('Goodness-of-fit sse')
    disp(GoF(i));
    idx=idx+1;
    if idx==obst_iter || GoF(i)<500
        iterating=0;
    end

end




toc



% plot
figure,axis equal,hold on; ms=8; lw=2; fs=16;
plot(M(1,:),M(2,:),'or','MarkerSize',ms,'LineWidth',lw);
plot(T(1,:),T(2,:),'sg','MarkerSize',ms,'LineWidth',lw);
plot(T_fit(1,:),T_fit(2,:),'xb','MarkerSize',ms,'LineWidth',lw);

for j=1:length(T_fit_obs)
    plot(T_fit_obs{j}(1,:),T_fit_obs{j}(2,:),'xb','MarkerSize',ms,'LineWidth',lw);
end


legend('data','model','model template','Location','NorthWest');
set(gca,'FontSize',fs);
