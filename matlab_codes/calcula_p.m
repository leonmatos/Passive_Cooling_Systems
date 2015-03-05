function p = calcula_p(A,s,sc_out,z,T,w,p0)

g = 9.81;
n = length(s);
Tmean = mean(T);
beta = calcula_beta(p0,Tmean);
rho0 = XSteam('rho_pT',p0,Tmean);
rho = rho0*(1-beta*(T-Tmean));
u = w./rho/A;

p = 0*s;
v = find(s == sc_out);
p(v) = p0*1e5;

for i = v+1:n
    p(i) = p(i-1) + .5*rho(i-1)*u(i-1)^2 + rho(i-1)*g*z(i-1)...
        - (.5*rho(i)*u(i)^2 + rho(i)*g*z(i));
end
i = 1;
p(i) = p(n) + .5*rho(n)*u(n)^2 + rho(n)*g*z(n)...
    - (.5*rho(i)*u(i)^2 + rho(i)*g*z(i));
for i = 2:v
    p(i) = p(i-1) + .5*rho(i-1)*u(i-1)^2 + rho(i-1)*g*z(i-1)...
        - (.5*rho(i)*u(i)^2 + rho(i)*g*z(i));
end

p = p*1e-5;