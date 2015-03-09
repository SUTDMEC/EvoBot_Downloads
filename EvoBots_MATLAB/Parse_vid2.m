function [ mean_framerate, vid_length, frameTimes,startFrame ] = Parse_vid2( filepath,filename )
%Parse_vid: parses videos to start when motion first begins. 
%   returns the frame timestamps for each of the frames and saves a version
%   of the video which starts at a specific moment in time

[video, audio] = mmread(strcat(filepath,'\',filename));
mean_framerate=video.rate;
vid_length=video.totalDuration;
frameTimes=video.times;
tic
hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port' ,'BlockSize', [35 35]);
mags=zeros(length(video.frames)-1,1);
for i=1:length(video.frames)-1
motion = step(hbm, im2double(rgb2gray(video.frames(i).cdata)), im2double(rgb2gray(video.frames(i+1).cdata)));
mags(i,1)=norm(motion);
moving=find(diff(mags)>400);
if length(moving)>0
    startFrame=moving(1);
    break
end
end
toc
end

