% natural convection in rectangular circuit of height H and width L
home,clear
path(path,'../../matlab_lib/XSteam_Matlab_v2.6')
%% INPUTS
L = .17*2+.8; % width (m)
H = 2.1; % height (m)
Lh = .8; % heater length (m)
D = .0110; %.0232; % piping diameter (m)
Q = 18;
U = 4;
p0 = 10; % circuit pressure (bar)
Ts = 15; % secondary side circuit temperature (C)
perturbation = .9; % perturbation
T0 = 48; % initial temperature (C)
n = 200; % number of points in the circuit
tmax = 300; % end time (s)
CFL = 1; % Courant-Friedrichs-Lewy
conv_criteria = .005;
%% geometry and mesh
ds = 2*(L+H)/n;
ny = round(H/(H+L)*n);
given_n = 0;
if rem(ny,2) > 0
    ny = ny-1;
    given_n = 1;
end
nx = round(L/(H+L)*n)+given_n;
ny = ny/2;
nx = nx/2;
A = .25*pi*D^2; % cross sectional area (m2)
L = (H+L)*2;
V = L*A; % total volume (m3)
phi = L/H;
j1 = nx; % corner heater x hot leg
j2 = nx+ny; % corner hot leg x cooler
j3 = 2*nx+ny; % corner cooler x cold leg
j4 = 2*nx+2*ny; % corner cold leg x heater
jh = round((ds*nx-Lh)/(ds*nx)*nx/2); % 1/4 of nodes on horizontal pipe
%% calculation of physical parameters
beta = calcula_beta(p0,T0); % thermal expansion coefficient (1/K)
mu = XSteam('my_pT',p0,T0); % dynamic viscosity (kg/m/s)
b = .7169; % exponent for Reynolds number
p = 21.3042; % model constant
g = 9.81; % gravity acceleration (m/s2)
cp = XSteam('cp_pT',p0,T0);
rho = XSteam('rho_pT',p0,T0);
Tsat = XSteam('Tsat_p',p0);
k = XSteam('tc_pT',p0,T0);
if exist('St')
    Re = (2/p*Gr*D/L)^(1/(3-b));
    U = St*Re*mu*cp/(4*L);
    Q = Gr*mu^3*A*cp/(D^3*rho^2*beta*H);
else
    Gr = D^3*rho^2*beta*g*Q*H/(mu^3*A*cp);
    Re = (2/p*Gr*D/L)^(1/(3-b));
    St = 4/Re*U*L/(mu*cp);
end
Pr = mu*cp/k;
Ra = Gr*Pr;
v = Re*(1e-6)/D;
dt = CFL*ds/v;
Wss = v*rho*A; % steady state mass flow (kg/s)
DTss = Q/Wss/cp; % steady state temperature difference in heater (C)
%% setting up z function and initial temperature field
T = [DTss*.5+T0+zeros(j2,1);-DTss*.5+T0+zeros(j2,1)];
z = 0*T; % elevation function
% heater
for j = 1:j1
    z(j) = 0;
end
% hot leg
for j = j1+1:j2
    z(j) = (j-j1)*ds;
end
% cooler
for j = j2+1:j3
    z(j) = H;
end
% cold leg
for j = j3+1:j4
    z(j) = z(j-1)-ds;
end
%% presentation of important problem parameters
fprintf('mass flow (kg/s): %2.4f\n',Wss)
fprintf('temp. diff. (C): %2.4f\n',DTss)
fprintf('heat input (kW): %2.4f\n',Q)
fprintf('heat capacity (kJ/kg/K): %2.4f\n',cp)
fprintf('glob. heat transf. coeff. (kW/m2/K): %2.4f\n',U)
fprintf('vol. flux (dm3/min): %2.4f\n',v*A*60*1000)
fprintf('flow velocity (m/s): %2.4f\n',v)
fprintf('mean friction coeff.: %2.4f\n',p/(Re^b))
fprintf('St: %2.4f\n',St)
fprintf('Gr: %2.4e\n',Gr)
fprintf('Re: %2.4f\n',Re)
fprintf('Pr: %2.4f\n',Pr)
fprintf('Ra: %2.4f\n',Ra)
%%
