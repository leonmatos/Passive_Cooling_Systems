function T = calcula_T_explicit(Tp,wp,rho,cp,D,Q,Lh,U,Ts,ds,dt,sh_in,sh_out,sc_in,sc_out,s)

A = .25*pi*D^2;
n = length(Tp);
T = 0*Tp;

wp = abs(wp);
for j = 2:n
    q = 0;
    if s(j) >= sh_in && s(j) <= sh_out
        q = 4*Q/(D^2*rho*cp*pi*Lh);
    elseif s(j) >= sc_in && s(j) <= sc_out
        q = -4*U*(Tp(j)-Ts)/(D*rho*cp);
    end
    T(j) = dt*(-wp/rho/A*(Tp(j)-Tp(j-1))/ds + q) + Tp(j);
end
T(1) = T(n);