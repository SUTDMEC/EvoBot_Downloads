
%kk=1;
function [newexitPolygon, newpipePolygon, EP, PP]=Obj_reco_final(ImageR,imfolder)


   try
   % imwrite(rgb2gray(imread('http://ai-ball.com/?action=snapshot')),'Scene.pgm');


exitsign = imread('exit.pgm');
pipeImage = imread('pipe.pgm');

cd(imfolder)
%figure; imshow(exitsign);
%title('Image of a exit');

sceneImage = ImageR;%imread(Image_name);
%figure; imshow(sceneImage);
%title('Image of a Cluttered Scene');

exitPoints = detectSURFFeatures(exitsign);
scenePoints = detectSURFFeatures(sceneImage);

%figure; imshow(exitsign);
%title('100 Strongest Feature Points from exit Image');
%hold on;
%plot(exitPoints.selectStrongest(100));

%figure; imshow(sceneImage);
%title('300 Strongest Feature Points from Scene Image');
%hold on;
%plot(scenePoints.selectStrongest(300));

[exitFeatures, exitPoints] = extractFeatures(exitsign, exitPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

exitPairs = matchFeatures(exitFeatures, sceneFeatures);

matchedexitPoints = exitPoints(exitPairs(:, 1), :);
matchedScenePoints = scenePoints(exitPairs(:, 2), :);
%figure;
%showMatchedFeatures(exitsign, sceneImage, matchedexitPoints, ...
 %   matchedScenePoints, 'montage');
%title('Putatively Matched Points (Including Outliers)');

[tform, inlierexitPoints, inlierScenePoints] = estimateGeometricTransform(matchedexitPoints, matchedScenePoints, 'affine');

%figure;
%showMatchedFeatures(exitsign, sceneImage, inlierexitPoints, ...
 %   inlierScenePoints, 'montage');
%title('Matched Points (Inliers Only)');

exitPolygon = [1, 1;...                           % top-left
        size(exitsign, 2), 1;...                 % top-right
        size(exitsign, 2), size(exitsign, 1);... % bottom-right
        1, size(exitsign, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
    newexitPolygon = transformPointsForward(tform, exitPolygon)
    
% % % %     figure; 
% % % %     imshow(sceneImage);
% % % %     pause(0.01)
% % % % hold on;
% % % % line(newexitPolygon(:, 1), newexitPolygon(:, 2), 'Color', 'g');
%title('Detected');

%%%%%%%%%%%%%%%%%%%%%%%%%


%figure; imshow(pipeImage);
%title('Image of a pipe');

pipePoints = detectSURFFeatures(pipeImage);
%figure; imshow(pipeImage);
%hold on;
%plot(pipePoints.selectStrongest(100));
%title('100 Strongest Feature Points from pipe Image');

[pipeFeatures, pipePoints] = extractFeatures(pipeImage, pipePoints);

pipePairs = matchFeatures(pipeFeatures, sceneFeatures, 'MaxRatio', 0.9);


matchedpipePoints = pipePoints(pipePairs(:, 1), :);
matchedScenePoints = scenePoints(pipePairs(:, 2), :);
%figure;
%showMatchedFeatures(pipeImage, sceneImage, matchedpipePoints, ...
 %   matchedScenePoints, 'montage');
%title('Putatively Matched Points (Including Outliers)');

[tform, inlierpipePoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedpipePoints, matchedScenePoints, 'affine');
%figure;
%showMatchedFeatures(pipeImage, sceneImage, inlierpipePoints, ...
 %   inlierScenePoints, 'montage');
%title('Matched Points (Inliers Only)');


pipePolygon = [1, 1;...                                 % top-left
        size(pipeImage, 2), 1;...                       % top-right
        size(pipeImage, 2), size(pipeImage, 1);...  % bottom-right
        1, size(pipeImage, 1);...                       % bottom-left
        1,1];                         % top-left again to close the polygon

newpipePolygon = transformPointsForward(tform, pipePolygon)


% figure; imshow(pipeImage);
% hold on;
% line(newexitPolygon(:, 1), newexitPolygon(:, 2), 'Color', 'y');
% title('Detected');


figg=figure('visible','on');
EP=length(exitPairs);
PP=length(pipePairs);
%figg=figure;
imshow(sceneImage);
%pause(0.02)
hold on;
if length(exitPairs)<5&&length(pipePairs)>25
line(newpipePolygon(:, 1), newpipePolygon(:, 2), 'Color', 'r');
elseif length(exitPairs)>5&&length(pipePairs)<25
    line(newexitPolygon(:, 1), newexitPolygon(:, 2), 'Color', 'g')
else
    line(newexitPolygon(:, 1), newexitPolygon(:, 2), 'Color', 'g');
line(newpipePolygon(:, 1), newpipePolygon(:, 2), 'Color', 'r');
end
hold on
%title('Detected pipe and exit');
%kk=kk+1;
saveas(figg,'figg.pgm');
%saveas(strcat('figg',num2str(kk),'pgm'))
%image(('figg.pgm'))

   catch 
%         EP=0;
%         PP=0;
%         [newexitPolygon,newpipePolygon, EP, PP]=Obj_reco_final(ImageR,imfolder)

%           try
%               figg=figure('visible','off');
%               imwrite(rgb2gray(imread('http://ai-ball.com/?action=snapshot')),'Scene.pgm');
%               sceneImage = imread('Scene.pgm');
%               imshow(sceneImage)
%               saveas(figg,'figg.pgm');
%               
%           catch
%           end
%         disp('Exception')
%         imwrite(rgb2gray(imread('http://ai-ball.com/?action=snapshot')),'figg.pgm');
%          catch
%          end

   end
 
  cd('C:\Users\SUTD\Documents\GitHub\STARScontrol')
end


