function R = residue_momentum(f,L,D,K,w,rho,beta,int_Tdz)

g = 9.81;
A = .25*pi*D^2;

R = abs(rho*beta*g*int_Tdz - (f*L/D+K)*w^2/2/rho/A^2);