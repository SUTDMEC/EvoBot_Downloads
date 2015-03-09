function [x,P] = EKF_Update(x,P,z,Ts)
% EKF   Extended Kalman Filter for nonlinear dynamic systems
% [x, P] = ekf(f,x,P,h,z,Q,R,Ts) returns state estimate, x and state covariance, P 
% for nonlinear dynamic system:
%           x_k+1 = f(x_k) + w_k
%           z_k   = h(x_k) + v_k
% where w ~ N(0,Q) meaning w is gaussian noise with covariance Q
%       v ~ N(0,R) meaning v is gaussian noise with covariance R
% Inputs:   f: function handle for f(x)
%           x: "a priori" state estimate
%           P: "a priori" estimated state covariance
%           h: fanction handle for h(x)
%           z: current measurement
%           Q: process noise covariance 
%           R: measurement noise covariance
% Output:   x: "a posteriori" state estimate

l = 0.11;
%the measurement covarience matrix for the case that the encoder data is
%more accurate then the optical flow data
R1 = diag([0.3,0.4,0.4,0.1,0.1]); 

%the measurement covarience matrix for the case that the optical flow data is
%more accurate then the encodee data. This can happen because of slippage
R2 = diag([0.3,0.1,0.1,1,1]); 

Q = eye(5);

diff = abs(z(2)+z(3)-(z(4)+z(5)))/(z(2)+z(3)+z(4)+z(5));

if diff>0.3
    if (z(2)+z(3))>(z(4)+z(5))
        R = R2;
    end
else
    R = R1;
end
f = @(x)[x(1)+Ts/2*(x(4)+x(5))*cos(x(3));
        x(2)+Ts/2*(x(4)+x(5))*sin(x(3));
        x(3)+Ts/l*(x(4)-x(5));
        x(4);
        x(5)];
        
h=@(x)[x(3);x(4);x(5);x(4);x(5)];

%Ts=0.032;
x1=f(x);
A=[1    0    -Ts/2*(x1(4)+x1(5))*sin(x1(3))    Ts/2*cos(x1(3))     Ts/2*cos(x1(3));
    0   1    Ts/2*(x1(4)+x1(5))*cos(x1(3))     Ts/2*sin(x1(3))     Ts/2*sin(x1(3));
    0   0    1                                Ts/l                -Ts/l;
    0   0    0                                1                  0;
    0   0    0                                0                  1];

P=A*P*A'+Q;                 %partial update
z1=h(x1);
H=[0 0 1 0 0    %the measurment jacoobian. the first row is \theta second and third
   0 0 0 1 0    % ones are right and left motor velocity from optical flow sensor
   0 0 0 0 1    % the forth and fifth are again right and left motor velocity 
   0 0 0 1 0    % from the encoders.
   0 0 0 0 1];
P12=P*H';                   %cross covariance
% K=P12*inv(H*P12+R);       %Kalman filter gain
% x=x1+K*(z-z1);            %state estimate
% P=P-K*P12';               %state covariance matrix
R=chol(H*P12+R);            %Cholesky factorization
U=P12/R;                    %K=U/R'; Faster because of back substitution
x=x1+U*(R'\(z-z1));         %Back substitution to get state update
P=P-U*U';                   %Covariance update, U*U'=P12/R/R'*P12'=K*P12.
end
