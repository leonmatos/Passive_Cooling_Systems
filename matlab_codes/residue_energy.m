function R = residue_energy(T,w,cp,D,Q,Lh,U,Ts,ds,sh_in,sh_out,sc_in,sc_out,s)

A = .25*pi*D^2;
n = length(s);
R = 0*T;

for j = 2:n
    if s(j) >= sh_in && s(j) <= sh_out % heater
        R(j) = w/A*(T(j)-T(j-1))/ds - 4*Q/(pi*D^2*cp*Lh);
    elseif s(j) >= sc_in && s(j) <= sc_out % cooler
        R(j) = w/A*(T(j)-T(j-1))/ds + 4*U*(T(j)-Ts)/(D*cp);
    else
        R(j) = w/A*(T(j)-T(j-1))/ds;
    end
end
R(1) = w/A*(T(1)-T(n))/ds;

R = norm(R);