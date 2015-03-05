function beta = calcula_beta(p,T)

delta = 20;
rho0 = XSteam('rho_pT',p,T);
rho1 = XSteam('rho_pT',p,T+delta);

beta = -(rho1/rho0-1)/delta;