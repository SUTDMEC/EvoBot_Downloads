function [ mean_framerate, vid_length, shotCount,changeFrame,startFrame ] = Parse_vid( filepath,filename )
%Parse_vid: parses videos to start when motion first begins. 
%   returns the frame timestamps for each of the frames and saves a version
%   of the video which starts at a specific moment in time

xyloObj = VideoReader(strcat(filepath,'\',filename),'Tag','My reader object');

mean_framerate=xyloObj.FrameRate;
vid_length=xyloObj.Duration;


NumTimes = 1;   % Number of times the stream processing loop should run
hmfr = vision.VideoFileReader( ...
    'Filename', strcat(filepath,'\',filename), ...
    'PlayCount',  NumTimes);

% Get the dimensions of each frame.
Info = info(hmfr);
rows = Info.VideoSize(2);  % Height in pixels
cols = Info.VideoSize(1);  % Width in pixels
blk_size = 32;  % Block size

% Create ROI rectangle indices for each block in image.
blk_rows = (1:blk_size:rows-blk_size+1);
blk_cols = (1:blk_size:cols-blk_size+1);
[X, Y] = meshgrid(blk_rows, blk_cols);
block_roi = [X(:)'; Y(:)'];
block_roi(3:4, :) = blk_size;
block_roi = block_roi([2 1 4 3], :)';
hedge = vision.EdgeDetector( ...
    'EdgeThinning' ,true, ...
    'ThresholdScaleFactor', 3);
hmean = vision.Mean;
hmean.ROIProcessing = true;

hVideo1 = vision.VideoPlayer;
hVideo1.Name  = 'Original Video';
% Video window position
hVideo1.Position(1) = round(0.4*hVideo1.Position(1));
hVideo1.Position(2) = round(1.5*(hVideo1.Position(2)));
hVideo1.Position([3 4]) = [400 200]; % video window size

hVideo2 = vision.VideoPlayer;
hVideo2.Name  = 'Sequence of start frames of the video shot.';
% Video window position
hVideo2.Position(1) = hVideo1.Position(1) + 410;
hVideo2.Position(2) = round(1.5* hVideo2.Position(2));
hVideo2.Position([3 4]) = [600 200];  % video window size

% Initialize variables.
mean_blks_prev = zeros([numel(X), 1], 'single');

scene_out      = zeros([rows, 3*cols, 3], 'single');
count          = 1;
frameCount     = 0;
shotCount      = 0;
changeFrame={};
increm=1;

while count <= NumTimes
    I = step(hmfr);              % Read input video

    % Calculate the edge-detected image for one video component.
    I_edge = step(hedge, I(:,:,3));

    % Compute mean of every block of the edge image.
    mean_blks = step(hmean, single(I_edge), block_roi);

    % Compare the absolute difference of means between two consecutive
    % frames against a threshold to detect a scene change.
    edge_diff = abs(mean_blks - mean_blks_prev);
    edge_diff_b = edge_diff > 0.08;
    num_changed_blocks = sum(edge_diff_b(:));
    % It is a scene change if there is more than one changed block.
    scene_chg = num_changed_blocks > 0.5;

    % Display the sequence of identified scene changes along with the edges
    % information. Only the start frames of the scene changes are
    % displayed.
    I_out = cat(2, I, repmat(I_edge, [1,1,3]));

    % Display the number of frames and the number of scene changes detected
    if scene_chg
        shotCount = shotCount + 1;
        changeFrame{count}(increm)=frameCount;
        increm=increm+1;
    end
    txt = sprintf('Frame %3d  Shot %d', frameCount, shotCount);
    I_out = insertText(I_out, [15 100], txt);

    % Generate sequence of scene changes detected
    if scene_chg
        % Shift old shots to left and add new video shot
        scene_out(:, 1:2*cols, :) = scene_out(:, cols+1:end, :);
        scene_out(:, 2*cols+1:end, :) = I;
        step(hVideo2, scene_out); % Display the sequence of scene changes
    end

    step(hVideo1, I_out);         % Display the Original Video.
    mean_blks_prev = mean_blks;      % Save block mean matrix

    if isDone(hmfr)
        count = count+1;
    end

    frameCount = frameCount + 1;
end

startFrame=changeFrame{1}(2);

release(hmfr);

end
