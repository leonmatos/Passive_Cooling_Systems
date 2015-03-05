function theta = calcula_theta_explicit(theta0,phi,w0,dt,ds,j,L,Lh,St)

j2 = j(2);
j3 = j(3);
j4 = j(4);
theta = 0*theta0;
n = length(theta);

% heater
for j = 2:j2
    theta(j) = theta0(j)*(1-phi*w0*dt/ds)+theta0(j-1)*phi*w0*dt/ds+L/Lh*dt;
end
% hot leg
for j = j2+1:j3
    theta(j) = theta0(j)*(1-phi*w0*dt/ds)+theta0(j-1)*phi*w0*dt/ds;
end
% cooler
for j = j3+1:j4
    theta(j) = theta0(j)*(1-phi*w0*dt/ds-St*dt)+theta0(j-1)*phi*w0*dt/ds;
end
% cold leg
for j = j4+1:n
    theta(j) = theta0(j)*(1-phi*w0*dt/ds)+theta(j-1)*phi*w0*dt/ds;
end

theta(1) = theta0(n);