function [final]=obj_detect(thresh)

%This function converts a colour image to a binary image threshholded at
%the level 'thresh' which is specified as one of the function inputs.
tic
A=imread('Frame_Image.bmp');
%A=imread('dartboard.png');
%A=imread('IMG_20140628_141138.jpg');
imshow(A)
pause
%A=double(A);
%comment these lines out if the image is not rgb
A=rgb2gray(A);
%A=A*256;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormap gray
s=size(A);
% % % %use filter if needed
% % % %Filter
% % % %Just an 8 neighbour averaging filter- Use only if needed%%%%%%%%%%%%
% for i=2:(s(1)-1)
%     for j=2:(s(2)-1)
%         A(i,j)=(A(i-1,j-1)+A(i-1,j)+A(i-1,j+1)+A(i,j-1)+A(i,j+1)+A(i,j)+A(i+1,j+1)+A(i+1,j)+A(i+1,j-1))/9;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Thresholding%%%%%%%%%%%%%%%%%%%
for i=1:s(1)
    for j=1:s(2)
        if A(i,j)<=thresh
            A(i,j)=0;
        else A(i,j)=255;
        end
    end
end
image(A)