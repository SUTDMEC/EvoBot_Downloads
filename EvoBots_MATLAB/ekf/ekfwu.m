function [x,P]=ekfwu(fstate,x,P,hmeas,z,Q,R,T,u)
% EKF   Extended Kalman Filter for nonlinear dynamic systems

try

% [x, P] = ekf(f,x,P,h,z,Q,R,u) returns state estimate, x and state covariance, P 
% for nonlinear dynamic system:
%           x_k+1 = f(x_k,u_k) + w_k
%           z_k   = h(x_k,u_k) + v_k
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
%           P: "a posteriori" state covariance
%
% Example:
%{
n=3;      %number of state
q=0.1;    %std of process 
r=0.1;    %std of measurement
Q=q^2*eye(n); % covariance of process
R=r^2;        % covariance of measurement  
f=@(x)[x(2);x(3);0.05*x(1)*(x(2)+x(3))];  % nonlinear state equations
h=@(x)x(1);                               % measurement equation
s=[0;0;1];                                % initial state
x=s+q*randn(3,1); %initial state          % initial state with noise
P = eye(n);                               % initial state covraiance
N=20;                                     % total dynamic steps
xV = zeros(n,N);          %estmate        % allocate memory
sV = zeros(n,N);          %actual
zV = zeros(1,N);
for k=1:N
  z = h(s) + r*randn;                     % measurments
  sV(:,k)= s;                             % save actual state
  zV(k)  = z;                             % save measurment
  [x, P] = ekfwu(f,x,P,h,z,Q,R);            % ekf 
  xV(:,k) = x;                            % save estimate
  s = f(s) + q*randn(3,1);                % update process 
end
for k=1:3                                 % plot results
  subplot(3,1,k)
  plot(1:N, sV(k,:), '-', 1:N, xV(k,:), '--',1:N,zV,'-r')
end
%}
% By Yi Cao at Cranfield University, 02/01/2008
% Modified by Sumeet Kumar at MIT to include process input in the state estimation
% process

if nargin == 8
    [x1,A]=jaccsd1(fstate,x,T);  %nonlinear update and linearization at current state
    P=A*P*A'+Q;                 %partial update
    [z1,H]=jaccsd1(hmeas,x1,T);  %nonlinear measurement and linearization
    P12=P*H';                   %cross covariance
elseif nargin == 9
    [x1,A]=jaccsd2(fstate,x,u,T);  %nonlinear update and linearization at current state
    P=A*P*A'+Q;                 %partial update
    [z1,H]=jaccsd2(hmeas,x1,u,T);  %nonlinear measurement and linearization
    P12=P*H';                   %cross covariance
end

K=P12*inv(H*P12+R);       %Kalman filter gain
x=x1+K*(z-z1);            %state estimate
P=P-K*P12';               %state covariance matrix
R=chol(H*P12+R);            %Cholesky factorization
U=P12/R;                    %K=U/R'; Faster because of back substitution
x=x1+U*(R'\(z-z1));         %Back substitution to get state update
P=P-U*U';                   %Covariance update, U*U'=P12/R/R'*P12'=K*P12.

catch err
    a=err.message
    b=err.stack.line
    keyboard
end

function [z,A]=jaccsd1(fun,x,T)
% JACCSD Jacobian through complex step differentiation
% Only differntiate with respect to variables in the first input
% [z J] = jaccsd(f,x)
% z = f(x,u)
% J = f'(x,u)|_x
%
try
z=fun(x,T);
n=numel(x);
m=numel(z);
A=zeros(m,n);
h=n*eps;
for k=1:n
    x1=x;
    x1(k)=x1(k)+h*1i;
    A(:,k)=imag(fun(x1,T))/h;
end
catch err
    keyboard
end

function [z,A] = jaccsd2(fun,x,u,T)
% JACCSD Jacobian through complex step differentiation
% Only differntiate with respect to variables in the first input
% [z J] = jaccsd(f,x)
% z = f(x,u)
% J = f'(x,u)|_x
%
z=fun(x,u,T);
n=numel(x);
m=numel(z);
A=zeros(m,n);
h=n*eps;
for k=1:n
    x1=x;
    x1(k)=x1(k)+h*1i;
    A(:,k)=imag(fun(x1,u,T))/h;
end