function omega = calcula_omega(L,D,Re,dt,Gr,thetaI,p,b,omega)

A =  p*L/D*dt/(2*Re^b);
C = - omega - Gr*thetaI*dt/Re^3;
b = 2-b;

w0 = omega*.9;

f = w0 + A*w0^b + C;
fp = A*b*w0^(b-1)+1;
w1 = w0 - f/fp;

nit = 1;
while abs((w1-w0)/w0) > .0001
    w0 = w1;
    f = w0 + A*w0^b + C;
    fp = A*b*w0^(b-1)+1;
    w1 = w0 - f/fp;
    nit = nit + 1;
end

omega = w1;