function [vx,vy,theta]=spliceSense(ms,en,nMouse,nEncode,method)
%spliceSense - takes various sensor data, and splices it in various ways to give 
%an output vector with a consistent measurement vector
%inputs: ms - mouse velocity estimate
% en - encoder velocity estimate
% nMouse - the number of mouse estimates relative to 1 encoder measurement
vx=zeros(1,length(ms.vx));
vy=zeros(1,length(ms.vx));
theta=zeros(1,length(ms.vx));
count=0;
% keyboard
ratio=nMouse/nEncode;

for i=1:length(ms.vx) %loop through all of the measured data
    if strcmp(method,'sample')
        if ratio >1 %meaning more mouse than encoder measurements
        if count<floor(ratio) %if the counter is less than the ratio of mouse/encoder measurements, populate using the mouse
            vx(i)=ms.vx(i);
            vy(i)=ms.vy(i);
            theta(i)=ms.theta(i);
            count=count+1;
        else
            vx(i)=en.vx(i);
            vy(i)=en.vy(i);
            theta(i)=en.theta(i);
            count=0;
        end
        else
            if count<floor(ratio*10) %if the counter is less than the ratio of mouse/encoder measurements, populate using the mouse
                vx(i)=en.vx(i);
                vy(i)=en.vy(i);
                theta(i)=ms.theta(i);
                count=count+1;
            else
                vx(i)=ms.vx(i);
                vy(i)=ms.vy(i);
                theta(i)=en.theta(i);
                count=0;
            end

        end
    elseif strcmp(method,'average')
        if ratio>1
            vx(i)=en.vx(i)*(1/ratio)+ms.vx(i)*(1-1/ratio);
            vy(i)=en.vy(i)*(1/ratio)+ms.vy(i)*(1-1/ratio);
            theta(i)=en.theta(i)*(1/ratio)+ms.theta(i)*(1-1/ratio);
        else
            vx(i)=en.vx(i)*(1-ratio)+ms.vx(i)*(ratio);
            vy(i)=en.vy(i)*(1-ratio)+ms.vy(i)*(ratio);
            theta(i)=en.theta(i)*(1-ratio)+ms.theta(i)*(ratio);
        end
    end
end

end

