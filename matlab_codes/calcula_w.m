function w = calcula_w(wp,L,D,K,f,rho,beta,int_Tdz,dt)
% After discretization, the momentum equation becomes a second order
% polinomial a*w^2 + b*w + c.

k = 1;
if wp < 0
	k = -1;
    wp = abs(wp);
end

A = .25*pi*D^2;
g = 9.81;

a = (f*L/D+K)/2/rho/A^2;
b = L/A/dt;
c = -L/A/dt*wp - rho*beta*g*int_Tdz;

w = (-b + sqrt(b^2-4*a*c))/2/a;
w = k*w;