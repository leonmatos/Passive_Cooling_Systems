function T = calcula_T_ss_implicit(Tp,R,w,rho,cp,D,Q,Lh,U,Ts,ds,...
    sh_in,sh_out,sc_in,sc_out,s,z)

A = .25*pi*D^2;
n = length(s);

M = sparse(n,n);
b = zeros(n,1);

dt = 10000/R;

M(1,1) = 1;
M(1,n) = -1;
for j = 2:n
    if s(j) >= sh_in && s(j) <= sh_out % heater
        M(j,j) = rho/dt + w/A/ds;
        M(j,j-1) = -w/A/ds;
        b(j) = 4*Q/(D^2*cp*pi*Lh) + rho/dt*Tp(j);
    elseif s(j) >= sc_in && s(j) <= sc_out % cooler
        M(j,j) = rho/dt + w/A/ds + 4*U/D/cp;
        M(j,j-1) = -w/A/ds;
        b(j) = 4*U*Ts/D/cp + rho/dt*Tp(j);
    else % pipes
        M(j,j) = rho/dt + w/A/ds;
        M(j,j-1) = -w/A/ds;
        b(j) = rho/dt*Tp(j);
    end
end

T = M\b;