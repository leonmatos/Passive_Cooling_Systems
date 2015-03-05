function theta = calcula_theta_implicit(theta0,phi,w0,dt,ds,j,L,Lh,St)

j1 = j(1);
j2 = j(2);
j3 = j(3);
j4 = j(4);
theta = 0*theta0;

n = length(theta);
A = sparse(n,n);
b = zeros(n,1);

%% primeira iteracao
j = 1;
A(j,j) = 1/dt+phi*w0/ds;
A(j,n) = -phi*w0/ds;
b(j) = theta0(j)/dt;
% heater
for j = 2:j2
    A(j,j) = 1/dt+phi*w0/ds;
    A(j,j-1) = -phi*w0/ds;
    b(j) = theta0(j)/dt+L/Lh;
end
% hot leg
for j = j2+1:j3
    A(j,j) = 1/dt+phi*w0/ds;
    A(j,j-1) = -phi*w0/ds;
    b(j) = theta0(j)/dt;
end
% cooler
for j = j3+1:j4
    A(j,j) = 1/dt+phi*w0/ds+St;
    A(j,j-1) = -phi*w0/ds;
    b(j) = theta0(j)/dt;
end
% cold leg
for j = j4+1:n
    A(j,j) = 1/dt+phi*w0/ds;
    A(j,j-1) = -phi*w0/ds;
    b(j) = theta0(j)/dt;
end
theta = inv(A)*b;
%% demais iteracoes
while abs(theta(1)-theta(end)) > .0001
    j = 1;
    A(j,j) = 1;
    A(j,n) = -1;
    b(j) = 0;
    % heater
    for j = 2:j2
        A(j,j) = 1/dt+phi*w0/ds;
        A(j,j-1) = -phi*w0/ds;
        b(j) = theta0(j)/dt+L/Lh;
    end
    % hot leg
    for j = j2+1:j3
        A(j,j) = 1/dt+phi*w0/ds;
        A(j,j-1) = -phi*w0/ds;
        b(j) = theta0(j)/dt;
    end
    % cooler
    for j = j3+1:j4
        A(j,j) = 1/dt+phi*w0/ds+St;
        A(j,j-1) = -phi*w0/ds;
        b(j) = theta0(j)/dt;
    end
    % cold leg
    for j = j4+1:n
        A(j,j) = 1/dt+phi*w0/ds;
        A(j,j-1) = -phi*w0/ds;
        b(j) = theta0(j)/dt;
    end
    theta = inv(A)*b;
end