function [x,P]=ekf_mr(fstate,x,P,hmeas,z,Q,R)
% EKF   Extended Kalman Filter for nonlinear dynamic systems
% [x, P] = ekf(f,x,P,h,z,Q,R) returns state estimate, x and state covariance, P 
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

l=0.11;
T=0.032;
% [x1,A]=jaccsd(fstate,x);    %nonlinear update and linearization at current state
x1=fstate(x);
% options = odeset('RelTol',1e-4,'AbsTol',[1e-6 1e-6 1e-6 1e-6 1e-6]);
% [tp,x1] = ode45(@conmodel,[tk,tk+T/200,tk+T],x);
% x1=x1(3,:)';
% A=jaccsd(@conmodel,x);
A=[1    0    -T/2*(x1(4)+x1(5))*sin(x1(3))    T/2*cos(x1(3))     T/2*cos(x1(3));
    0   1    T/2*(x1(4)+x1(5))*cos(x1(3))     T/2*sin(x1(3))     T/2*sin(x1(3));
    0   0    1                                T/l                -T/l;
    0   0    0                                1                  0;
    0   0    0                                0                  1];

% A=[ 1    0    0    1    0;
%     0    1    0    0    1;
%     0    0    1    0    0;
%     0    0    0    1    0;
%     0    0    0    0    1];

P=A*P*A'+Q;                 %partial update
% [z1,H]=jaccsd(hmeas,x1);    %nonlinear measurement and linearization
z1=hmeas(x1);
H=[0 0 1 0 0
   0 0 0 1 0
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
% 
% function dx=conmodel(t,x)
%        dx=zeros(5,1);
%        dx(1)=1/2*(x(4)+x(5))*cos(x(3));
%        dx(2)=1/2*(x(4)+x(5))*sin(x(3));
%        dx(3)=1/0.11*(x(4)-x(5));
%        dx(4)=x(4);
%        dx(5)=x(5);
% end
% 
% function A=jaccsd(fun,x)
% % JACCSD Jacobian through complex step differentiation
% % [z J] = jaccsd(f,x)
% % z = f(x)
% % J = f'(x)
% %
% z=fun(x);
% n=numel(x);
% m=numel(z);
% A=zeros(m,n);
% h=n*eps;
% for k=1:n
%     x1=x;
%     x1(k)=x1(k)+h*i;
%     A(:,k)=imag(fun(x1))/h;
% end
% end