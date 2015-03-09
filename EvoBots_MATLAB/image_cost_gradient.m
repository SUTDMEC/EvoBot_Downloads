function [final]=image_cost_gradient(thresh)

%This function converts a colour image to an obstacle map. The obstacles must
%ideally be dark in colour. One may need to change the input parameter 'thresh'to
%obtain a good obstacle map. The quality of the function depends on
%lighting conditions, brightness of the obstacles and that of the
%environment

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
%use filter if needed
%Filter
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Dilation%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=3;
se=ones(2*N+1,2*N+1);
G=[];%G is the inverted version of A
for i=1:s(1)
    for j=1:s(2)
        if A(i,j)>0
            G(i,j)=0;
        else G(i,j)=255;
        end
    end
end
% imshow(G)
% pause
G_dilated=imdilate(G,se);
% imshow(G)
% pause
% imshow(G_dilated)
% pause

m=1;
for i=1:50
    G_old=G_dilated;
    G_dilated=imdilate(G_old,se);
    diff{i}=m*(G_dilated-G_old);
    m=0.9*m;
end
d=zeros(size(G));
for i=1:length(diff)
    d=[d+diff{i}];
end
d=d/length(diff);
D=reshape(d,s(1)*s(2),1);
maxd=max(D);
d=256*d/maxd;
d=uint8(d);
G=imdilate(G,se);
final=(uint8(G)+d);
imshow(final);
toc

%imshow(G_dilated-G)

% for i=1:s(1)
%     for j=1:s(2)
%         if A(i,j)-B(i,j)>0
%             [closei,closej]=closest_pt(edgeA,i,j);
%             G(i,j)=255*s(2)/abs(((closei-i)^2)+(closej-j)^2);%proportional to the distance from the original object;
%         end
%     end
% end

            