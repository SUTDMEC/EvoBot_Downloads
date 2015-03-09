function y = statupd(x,u,T)
    if(x(3)>=5)
        y = [0;0;0;0;0;0;0;x(1)+T*x(3)*cos(x(4));x(2)+T*x(3)*sin(x(4));x(3)+T*u(1);x(4)+T*u(2)/x(3)];
    else
        y = [0;0;0;0;0;0;0;x(1)+T*x(3)*cos(x(4));x(2)+T*x(3)*sin(x(4));x(3)+T*u(1);x(4)];
    end
end

