function [x,P]=ekfwu(fstate,x,P,hmeas,z,Q,R,u,T)

try

if nargin == 7
    T=0.1;
    [x1,A]=jaccsd1(fstate,x,T);  %nonlinear update and linearization at current state
    P=A*P*A'+Q;
    %partial update
    [z1,H]=jaccsd1(hmeas,x1,T);  %nonlinear measurement and linearization
    P12=P*H';                   %cross covariance

elseif nargin == 8
    [x1,A]=jaccsd1(fstate,x,T);  %nonlinear update and linearization at current state
    P=A*P*A'+Q;
    %partial update
    [z1,H]=jaccsd1(hmeas,x1,T);  %nonlinear measurement and linearization
    P12=P*H';                   %cross covariance
elseif nargin == 9
    [x1,A]=jaccsd2(fstate,x,u,T);  %nonlinear update and linearization at current state
    P=A*P*A'+Q;
    %partial update
    [z1,H]=jaccsd2(hmeas,x1,u,T);  %nonlinear measurement and linearization
    P12=P*H';                   %cross covariance
end

% K=P12*inv(H*P12+R);       %Kalman filter gain
% % pause
% x=x1+K*(z-z1);            %state estimate
% P=P-K*P12';               %state covariance matrix

R=chol(H*P12+R);            %Cholesky factorization - EW: don't update the measurement noise covariance

U=P12/R;                    %K=U/R'; Faster because of back substitution
x=x1+U*(R'\(z-z1));         %Back substitution to get state update
P=P-U*U';                   %Covariance update, U*U'=P12/R/R'*P12'=K*P12.

catch err
    a=err.stack.line
    b=err.message
    keyboard
end


function [z,A]=jaccsd1(fun,x,T)
% JACCSD Jacobian through complex step differentiation
% Only differntiate with respect to variables in the first input
% [z J] = jaccsd(f,x)
% z = f(x,u)
% J = f'(x,u)|_x
%
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