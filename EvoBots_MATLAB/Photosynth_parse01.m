%This script processes the videos into frames for photosynth

% filepath='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\Photosynthvids\';
% filepath='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\CoSLAMtestWorking\';
filepath='C:\Users\Erik Wilhelm\Documents\Big Data (not backed up)\SUTD_data\EvoBots\';
% filename={'vid1WORKING.avi' 'vid4ALSOWORKING.avi' 'vid4WORKING.avi' 'vid5ALSOWORKING.avi' 'vid5WORKING.avi' 'vid6WORKING.avi'};
% filename={'vid1.avi' 'vid2.avi' 'vid3.avi'};
filename={'20141016_154903_TL.mp4'};
vid_to_analyze=1;

save_folder=strsplit(filename{vid_to_analyze},'.');
save_folder=strcat(save_folder{1},'\');

mkdir(strcat(filepath,save_folder))

%find start frame 
% [ mean_framerate, vid_length, frameTimes,startFrame ] = Parse_vid2( filepath,filename{vid_to_analyze} );
% 
% stepSize=floor(mean_framerate/2/10); %take one frame per second

%re-read the video (waste of time)
obj = mmread(strcat(filepath,filename{vid_to_analyze}));
keyboard
for k = startFrame: stepSize : length(frameTimes)  %fill in the appropriate number
  thisFrame = obj.frames(k).cdata;
  imwrite(imrotate(thisFrame,-90),strcat(filepath,save_folder,'frame',num2str(k),'.jpg'));
end

