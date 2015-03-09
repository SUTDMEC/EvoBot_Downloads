function out = EvoOptical (in)
% this function is a wrapper for the KTTI optical flow dead reconning code
% try
disp('===========Running Visual SLAM==============');

d = dir(strcat(in.image_dir,'*.png'));

dates=[d.datenum]; %get all the timestamps when the vids were created

[sorted,idx] = sort(dates,'ascend');
for i=1:length(idx)
    newfile_name{i}=d(idx(i)).name; %sort the pictures according to their date shot
end

%Webcam params
img_dir     = in.image_dir; %'C:\Users\Erik Wilhelm\Documents\MATLAB\SUTD_code\SLAM\trunk\sequences\test7';
param.f      = 659.62;
param.cu     = 344.31;
param.cv     = 303.13;
param.height = 0.12;
param.pitch  = -0.08;
first_frame  = 1;
last_frame   = length(d);

% init visual odometry
visualOdometryMonoMex('init',param);

% init transformation matrix array
Tr_total{1} = eye(4);

% create figure
figure('Color',[1 1 1]);
ha1 = axes('Position',[0.05,0.7,0.9,0.25]);
axis off;
ha2 = axes('Position',[0.05,0.05,0.9,0.6]);
set(gca,'XTick',-500:10:500);
set(gca,'YTick',-500:10:500);
axis equal, grid on, hold on;


% for all frames do
replace = 0;
for frame=first_frame:last_frame
  
  % 1-based index
  k = frame-first_frame+1;
  
  % read current images
%   I = imread([img_dir '/I1_' num2str(frame,'%06d') '.png']); %for original test images
%   I = imread([img_dir '/frame-' num2str(frame,'%01d') '.pgm']); %for samsung camera images
%   I=imrotate(I,-90);

% I = imread([img_dir '/Image (' num2str(frame,'%01d') ').jpg']); %for drop-box evobot web camera images
%   I = imread([img_dir '/ImageNumber' num2str(frame,'%01d') '.jpg']); %for evobot web camera images
I = imread(strcat(in.image_dir,newfile_name{k})); %for robotic images
imwrite(I,strcat(in.image_dir,'Conversion.pgm')); %REMOVE ONCE THOMMEN FORMATS HIS SAVE
I=imread(strcat(in.image_dir,'Conversion.pgm'));

  % compute egomotion
  Tr = visualOdometryMonoMex('process',I,replace);
  
  % accumulate egomotion, starting with second frame
  if k>1
    
    % if motion estimate failed: set replace "current frame" to "yes"
    % this will cause the "last frame" in the ring buffer unchanged
    if isempty(Tr)
      replace = 1;
      Tr_total{k} = Tr_total{k-1};
      
    % on success: update total motion (=pose)
    else
      replace = 0;
      Tr_total{k} = Tr_total{k-1}*inv(Tr);
    end
  end

  % update image
  axes(ha1); cla;
  imagesc(I); colormap(gray);
  axis off;
  
  % update trajectory
  axes(ha2);
  if k>1
    plot([Tr_total{k-1}(1,4) Tr_total{k}(1,4)], ...
         [Tr_total{k-1}(3,4) Tr_total{k}(3,4)],'-xb','LineWidth',1);
  end
  pause(0.05); refresh;

  % output statistics
  num_matches = visualOdometryMonoMex('num_matches');
  num_inliers = visualOdometryMonoMex('num_inliers');
  disp(['Frame: ' num2str(frame) ...
        ', Matches: ' num2str(num_matches) ...
        ', Inliers: ' num2str(100*num_inliers/num_matches,'%.1f') ,' %']);
end

% release visual odometry
visualOdometryMonoMex('close');


out.dx=Tr_total{end}(1,4)-Tr_total{1}(1,4);
out.dy=Tr_total{end}(3,4)-Tr_total{1}(3,4);

% catch
%     a=lasterror
%     keyboard
% end