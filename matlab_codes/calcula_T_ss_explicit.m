function T = calcula_T_ss_explicit(Tp,R,w,rho,cp,D,Q,Lh,U,Ts,ds,...
    sh_in,sh_out,sc_in,sc_out,s,z)

A = .25*pi*D^2;
n = length(s);
T = 0*s;
dt = 10/R;

% zh_in = z(s == sh_in);
% zh_out = z(s == sh_out);
% w = sign(zh_out-zh_in)*w;

T(1) = Tp(1);
for j = 2:n
    if s(j) >= sh_in && s(j) <= sh_out % heater
        T(j) = (4*Q/(D^2*cp*pi*Lh)+rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds);
    elseif s(j) >= sc_in && s(j) <= sc_out % cooler
        T(j) = (4*U*Ts/D/cp+rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds+4*U/D/cp);
    else % pipes
        T(j) = (rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds);
    end
end
T(1) = T(n);

nit = 1;
while abs(norm(T)-norm(Tp)) > 1e-3 && nit <= 1e3
    Tp = T;
    for j = 2:n
        if s(j) >= sh_in && s(j) <= sh_out % heater
            T(j) = (4*Q/(D^2*cp*pi*Lh)+rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds);
        elseif s(j) >= sc_in && s(j) <= sc_out % cooler
            T(j) = (4*U*Ts/D/cp+rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds+4*U/D/cp);
        else % pipes
            T(j) = (rho/dt*Tp(j)+w/A/ds*T(j-1))/(rho/dt+w/A/ds);
        end
    end
    T(1) = T(n);
    nit = nit + 1;
end