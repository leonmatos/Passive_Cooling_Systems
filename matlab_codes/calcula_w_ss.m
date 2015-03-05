function w = calcula_w_ss(wp,R,L,D,K,f,rho,beta,int_Tdz,zh_in,zh_out)
% After discretization, the momentum equation becomes a second order
% polinomial a*w^2 + b*w + c = 0.

A = .25*pi*D^2;
g = 9.81;
dt = 10000/R;

a = (f*L/D+K)/2/rho/A^2;
b = L/A/dt;
c = -L/A/dt*wp - rho*beta*g*int_Tdz;

w = (-b + sqrt(b^2-4*a*c))/2/a;

% if w > 0
%     if zh_in > zh_out
%         w = -w;
%     end
% end