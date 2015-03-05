function Y = nayak_characteristic_function(n,run_file)

load(run_file);
Vh = A*Lh;
theta_hl = (T(j3)-Ts)/(T(j2)-T(j1));
S_h  = s(j2)/H;
S_hl = s(j3)/H;
S_c  = s(j4)/H;
S_t  = max(s)/H;
S_x  = .17/H;
%% corrigindo p
% p = 22.26;
% b = .6744;
%%

B = V/(n*Vh)*exp(-n/phi*S_c)*(1-exp(n/phi*S_h));

C = theta_hl*St/n*(1-exp(n*(S_hl-S_c)/phi));

DD = exp(-St*(S_hl-S_c)/phi)-exp(-n*S_t/phi);

X = (B+C)/DD;

thetas_omega = V/(n*Vh)*(exp(-n*S_h/phi)-1)...
    + (exp(-n*(S_c-S_t-S_h)/phi)-1)*X;

Y = n - Gr/Re^3*phi/n*(1-exp(-n/phi))*exp(-n*S_x/phi)*thetas_omega...
    + p*L/D*(2-b)/(2*Re^b);