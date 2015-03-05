function T = calcula_T_implicit(Tp,wp,rho,cp,D,Q,Lh,U,Ts,ds,dt,sh_in,sh_out,sc_in,sc_out,s)
% this function calculates T by solving M*T = b

A = .25*pi*D^2;
n = length(Tp);

M = sparse(n,n);
b = zeros(n,1);

M(1,1) = 1;
M(1,n) = -1;
for j = 2:n
    M(j,j) = 1/dt + wp/rho/A/ds;
	M(j,j-1) = -wp/rho/A/ds;
    b(j) = Tp(j)/dt;
    if s(j) >= sh_in && s(j) <= sh_out % heater
        b(j) = b(j) + 4*Q/(D^2*rho*cp*pi*Lh);
    elseif s(j) >= sc_in && s(j) <= sc_out % cooler
        M(j,j) = M(j,j) + 4*U/(D*rho*cp);
        b(j) = b(j) + 4*U*Ts/(D*rho*cp);
    end
end
% T = inv(M)*b;
T = M\b;