clear
clc
% close all
filename='data1_Evobot.csv';
sheet=1;
Motor_command=xlsread(filename, sheet, 'O3:P906');% full power camera on
Robot1 = xlsread(filename, sheet, 'I3:K906');% full power camera on
IND=0:length(Robot1);
nonz=Motor_command>0;
nonz=nonz(:,1)+nonz(:,2);
nonz=nonz>0;
Yaw1=degtorad(Robot1(:,1)-Robot1(1,1)+90);
mouseData1.d_x=Robot1(:,2);
mouseData1.d_y=Robot1(:,3);
Yaw1=Yaw1(nonz);
mouseData1.d_x=mouseData1.d_x(nonz);
mouseData1.d_y=mouseData1.d_y(nonz);
[Vr1,Vl1]=mouseVel(mouseData1,Yaw1);


filename='data2_Evobot.csv';
Motor_command=xlsread(filename, sheet, 'O3:P906');% full power camera on
Robot2 = xlsread(filename, sheet, 'I3:K906');% full power camera on
IND=0:length(Robot2);
nonz=Motor_command>0;
nonz=nonz(:,1)+nonz(:,2);
nonz=nonz>0;
Yaw2=degtorad(Robot2(:,1)-Robot2(1,1)+90);
mouseData2.d_x=Robot2(:,2);
mouseData2.d_y=Robot2(:,3);
Yaw2=Yaw2(nonz);
mouseData2.d_x=mouseData2.d_x(nonz);
mouseData2.d_y=mouseData2.d_y(nonz);
[Vr2,Vl2]=mouseVel(mouseData2,Yaw2);

filename='data3_Evobot.csv';
Motor_command=xlsread(filename, sheet, 'O3:P906');% full power camera on
Robot3 = xlsread(filename, sheet, 'I3:K906');% full power camera on
IND=0:length(Robot3);
nonz=Motor_command>0;
nonz=nonz(:,1)+nonz(:,2);
nonz=nonz>0;
Yaw3=degtorad(Robot3(:,1)-Robot3(1,1)+90);
mouseData3.d_x=Robot3(:,2);
mouseData3.d_y=Robot3(:,3);
Yaw3=Yaw3(nonz);
mouseData3.d_x=mouseData3.d_x(nonz);
mouseData3.d_y=mouseData3.d_y(nonz);
[Vr3,Vl3]=mouseVel(mouseData3,Yaw3);





load ground_truth;
Pos1=ground_truth(1,:);
Pos2=ground_truth(2,:);
Pos3=ground_truth(3,:);


T=0.032;
n=5;
q=.1;    %std of process 
r=1;    %std of measurement
Q=q^2*eye(n); % covariance of process
R=r^2*eye(3);        % covariance of measurement  
l=0.11;
f=@(x)[x(1)+T/2*(x(4)+x(5))*cos(x(3));
        x(2)+T/2*(x(4)+x(5))*sin(x(3));
        x(3)+T/l*(x(4)-x(5));
        x(4);
        x(5)];

        
h=@(x)[x(3);x(4);x(5)];


s1=[Pos1(1),-Pos1(3),pi/2,0,0]';
x1=s1;


s2=[Pos2(1)+1,-Pos2(3),pi/2,0,0]';
x2=s2;


s3=[Pos3(1),-Pos3(3),pi/2,0,0]';
x3=s3;


P = 1*eye(n);                               % initial state covraiance
N=min([length(Yaw1) length(Yaw3) length(Yaw2)]);                                     % total dynamic steps
xV1 = zeros(n,N);          %estmate        % allocate memory
zV1 = zeros(3,N);
xV2 = zeros(n,N);          %estmate        % allocate memory
zV2 = zeros(3,N);
xV3 = zeros(n,N);          %estmate        % allocate memory
zV3 = zeros(3,N);
sV1 = zeros(n,N);
sV2 = zeros(n,N);
sV3 = zeros(n,N);
xsV1 = zeros(2,N);
xsV2 = zeros(2,N);
xsV3 = zeros(2,N);

xsV1(:,1)=[Pos1(1),-Pos1(3)]';
xsV2(:,1)=[Pos2(1),-Pos2(3)]';
xsV3(:,1)=[Pos3(1),-Pos3(3)]';

D_x1=zeros(1,N);
D_y1=zeros(1,N);
D_x2=zeros(1,N);
D_y2=zeros(1,N);
D_x3=zeros(1,N);
D_y3=zeros(1,N);

for k=1:N
    
    
    
  D_x1(k)=mouseData1.d_y(k)/1000.*cos(Yaw1(k));
  D_y1(k)=mouseData1.d_y(k)/1000.*sin(Yaw1(k));    
  z1 = [Yaw1(k),Vr1(k),Vl1(k)]';                     % measurments
  xsV1(:,k+1)=xsV1(:,k)+[D_x1(k),D_y1(k)]';
  zV1(:,k)  = z1; 
  sV1(:,k)= s1; 
  xV1(:,k) = x1;% save measurment 
  [x1, P] = ekf_mr(f,x1,P,h,z1,Q,R);            % ekf 
%   s1(3)=Yaw1(k);
  s1(4)=Vl1(k);
  s1(5)=Vr1(k);
  s1 = f(s1);
  
  D_x2(k)=mouseData2.d_y(k)/1000.*cos(Yaw2(k));
  D_y2(k)=mouseData2.d_y(k)/1000.*sin(Yaw2(k));
  z2 = [Yaw2(k),Vr2(k),Vl2(k)]';                     % measurments
  xsV2(:,k+1)=xsV2(:,k)+[D_x2(k),D_y2(k)]';
  zV2(:,k)  = z2; 
  sV2(:,k)= s2;
  xV2(:,k) = x2;% save measurment 
  [x2, P] = ekf_mr(f,x2,P,h,z2,Q,R);            % ekf 
%   s2(3)=Yaw2(k);
  s2(4)=Vl2(k);
  s2(5)=Vr2(k);
  s2 = f(s2);
  
  D_x3(k)=mouseData3.d_y(k)/1000.*cos(Yaw3(k));
  D_y3(k)=mouseData3.d_y(k)/1000.*sin(Yaw3(k));
  z3 = [Yaw3(k),Vr3(k),Vl3(k)]';                     % measurments
  xsV3(:,k+1)=xsV3(:,k)+[D_x3(k),D_y3(k)]';
  zV3(:,k)  = z3; 
  sV3(:,k)= s3;
  xV3(:,k) = x3;% save measurment 
  [x3, P] = ekf_mr(f,x3,P,h,z3,Q,R);            % ekf 
%   s3(3)=Yaw3(k);
  s3(4)=Vl3(k);
  s3(5)=Vr3(k);
  s3 = f(s3);
  
end

%%
% filename='Take 2014-10-19 02.53.23 PM.csv';
% sheet=1;
% ground_truth=xlsread(filename, sheet, 'H49:J122647');% full power camera on


for i=2:length(ground_truth)
    if mod(i,4)==0
        Pos1=[Pos1;ground_truth(i-3,:)];
        Pos2=[Pos2;ground_truth(i-2,:)];
        Pos3=[Pos3;ground_truth(i-1,:)];
    end
end
Pos2(:,1)=Pos2(:,1)+1;


figure;
hold on;
grid on;
xlim([-1 2]);
ylim([-1 1]);
xlabel('X');
ylabel('Y');
plot(Pos1(:,1),-Pos1(:,3),'r','linewidth',3)
plot(xV1(1,:),xV1(2,:),'--b','linewidth',3)
plot(sV1(1,:),sV1(2,:),'-.m','linewidth',3)
plot(xsV1(1,:),xsV1(2,:),':g','linewidth',3)
legend('Ground Truth','Estimated','Just Model', 'Measurment Only')

% figure
% hold on;
% grid on;
% xlim([-1 1]);
% ylim([-0.5 1.5]);
plot(Pos2(:,1),-Pos2(:,3),'r','linewidth',3)
plot(xV2(1,:),xV2(2,:),'--b','linewidth',3)
plot(sV2(1,:),sV2(2,:),'-.m','linewidth',3)
plot(xsV2(1,:)+1,xsV2(2,:),':g','linewidth',3)
% legend('Ground Truth','Estimated','Just Model', 'Measurment Only')


% figure;
% hold on;
% grid on;
% xlim([-1.5 1.5]);
% ylim([-2 1]);
% plot(Pos3(:,1),-Pos3(:,3),'r','linewidth',3)
% plot(xV3(1,:),xV3(2,:),'--b','linewidth',3)
% plot(sV3(1,:),sV3(2,:),'-.m','linewidth',3)
% plot(xsV3(1,:),xsV3(2,:),'g','linewidth',3)
% legend('Ground Truth','Estimated','Just Model', 'Measurment Only')




