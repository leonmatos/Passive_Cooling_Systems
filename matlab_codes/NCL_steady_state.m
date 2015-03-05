function [f,rho,beta,cp,w,T,Re,St,Gr] = NCL_steady_state(input_var,in1,in2,s,z,ds,L,Lh,H,D,K,...
    sh_in,sh_out,sc_in,sc_out,p,b,p0,uini,Ts,advance_scheme)

if strcmp(input_var,'St-Gr')
    St = in1;
    Gr = in2;
elseif strcmp(input_var,'Q-U')
    Q = in1;
    U = in2;
else
    disp('first input argument is wrong!')
end
%% calculation of physical and geometric parameters
conv_criterion = 1e-2;
zh_in = z(s == sh_in);
zh_out = z(s == sh_out);
zc_in = z(s == sc_in);
zc_out = z(s == sc_out);
DH = (zc_in + zc_out)/2-(zh_in + zh_out)/2;
A = .25*pi*D^2;
beta = calcula_beta(p0,Ts); % thermal expansion coefficient (1/K)
mu = XSteam('my_pT',p0,Ts); % dynamic viscosity (kg/m/s)
g = 9.81; % gravity acceleration (m/s2)
cp = XSteam('cp_pT',p0,Ts);
rho = XSteam('rho_pT',p0,Ts);
Tsat = XSteam('Tsat_p',p0);
Re = D*abs(uini)*rho/mu;
if exist('Q','var')
    Gr = D^3*rho^2*beta*g*Q*DH/(mu^3*A*cp);
    St = 4*U*L/(mu*Re*cp);
else
    Q = Gr*mu^3*A*cp/(D^3*rho^2*beta*g*DH);
    U = St*mu*Re*cp/(4*L);
end
w = uini*rho*A; % steady state mass flow (kg/s)
if strcmp(p,'poiseuille-colebrook')
    f = poiseuille_colebrook_friction(D,Re,1e-7);
elseif strcmp(p,'churchill')
    f = churchill_friction(D,Re,1e-7);
else
    f = p/Re^b;
end
%% presentation of important problem parameters
fprintf('---------------------------\n');
print_current_time('simulation started at ')
W = L/2-H;
ho = 'H'; co = 'V';
if sh_in > W
    ho = 'V';
end
if sc_in > W+H && sc_out < 2*W+H
    co = 'H';
end
% disp('INITIAL CONDITIONS:')
disp([ho,'H',co,'C']),clear W ho co
% fprintf('Q (kW): %2.4f\n',Q)
% fprintf('U (kW/m2/K): %2.4f\n',U)
% fprintf('w (kg/s): %2.4f\n',w)
% fprintf('wss_teo (kg/s): %2.4f\n',wss_teo)
% fprintf('DT (C): %2.4f\n',DT)
% fprintf('Tmean (C): %2.4f\n',Tini)
% if strcmp(p,'poiseuille-colebrook')
%     fprintf('f: %2.4f (using Poiseuille-Colebrook)\n',f)
% elseif strcmp(p,'churchill')
%     fprintf('f: %2.4f (using Churchill)\n',f)
% else
%     fprintf('f: %2.4f\n',f)
% end
% fprintf('St: %2.4f\n',St)
% fprintf('Gr: %2.4e\n',Gr)
% fprintf('Re: %2.4f\n',Re)
disp([advance_scheme,' scheme'])
%% initialization
Tp = 0*s+Ts;
T = Tp; 
DT = 100;
converged = 0;
nit = 1;
nitmax = 4e2;
R_m = 1000;
R_e = 1000;
while (R_m > conv_criterion || R_e > conv_criterion) && nit <= nitmax
    %% calculation
    if strcmp(advance_scheme,'explicit')
        T = calcula_T_ss_explicit(Tp,max(R_m,R_e),w,rho,cp,D,Q,Lh,U,Ts,ds,sh_in,sh_out,sc_in,sc_out,s,z);
    else
        T = calcula_T_ss_implicit(Tp,max(R_m,R_e),w,rho,cp,D,Q,Lh,U,Ts,ds,sh_in,sh_out,sc_in,sc_out,s,z);
    end
%     show_temp_profile(w,T,s,sh_in,sh_out,sc_in,sc_out),drawnow
    Tp = T;
    Tmean = mean(T);
    if Tmean >= Tsat
        break
    end
    R_e = residue_energy(T,w,cp,D,Q,Lh,U,Ts,ds,sh_in,sh_out,sc_in,sc_out,s);
    int_Tdz = integra_T(T,z);
    w = calcula_w_ss(w,max(R_m,R_e),L,D,K,f,rho,beta,int_Tdz,zh_in,zh_out);
    R_m = residue_momentum(f,L,D,K,w,rho,beta,int_Tdz);
%     fprintf('%2.4f   %2.4f\n',R_m,R_e)
    %% recalculation of physical parameters
    beta = calcula_beta(p0,Tmean);
    mu = XSteam('my_pT',p0,Tmean);
    cp = XSteam('cp_pT',p0,Tmean);
    rho = XSteam('rho_pT',p0,Tmean);
    Re = 4*abs(w)/pi/D/mu;
    if strcmp(input_var,'Q-U')
        Gr = D^3*rho^2*beta*g*Q*DH/(mu^3*A*cp);
        St = 4*U*L/(mu*Re*cp);
    else
        Q = Gr*mu^3*A*cp/(D^3*rho^2*beta*g*DH);
        U = St*mu*Re*cp/(4*L);
    end
    if strcmp(p,'poiseuille-colebrook')
        f = poiseuille_colebrook_friction(D,Re,1e-7);
    elseif strcmp(p,'churchill')
        f = churchill_friction(D,Re,1e-7);
    else
        f = p/Re^b;
    end
    DT = Q/w/cp;
    u = w/rho/A;
    nit = nit + 1;
end
fprintf('\n');
%%
if R_m <= conv_criterion && R_e <= conv_criterion
    converged = 1;
end
if converged
    if strcmp(p,'poiseuille-colebrook')||strcmp(p,'churchill')
        wss_teo = nan;
    else
        wss_teo = (2*D^b*rho^2*beta*g*A^(2-b)*Q*H/(p*cp*mu^b*L/D))^(1/(3-b));
    end
    pressure = calcula_p(A,s,sc_out,z,T,w,p0);
    p_in = pressure(s == sh_in);
    p_out = pressure(s == sh_out);
    p_drop = p_in - p_out;
    Richardson_crit = Ri_crit(St,D,H,(L-2*H)/2,L,Lh);
    Richardson = Ri(T,z,H,L,f);
    % plot(s,pressure,'k'),xlabel('loop coordinate (m)'),ylabel('pressure (bar)'),grid on
    disp('STEADY STATE CONDITIONS:')
    fprintf('Q (kW): %2.4f\n',Q)
    fprintf('U (kW/m2/K): %2.4f\n',U)
    fprintf('wss (kg/s): %2.4f\n',w)
    if ~(strcmp(p,'poiseuille-colebrook')||strcmp(p,'churchill'))
        fprintf('wss_teo (kg/s): %2.4f\n',wss_teo)
    end
    fprintf('u (m/s): %2.4f\n',u)
    fprintf('DT (C): %2.4f\n',DT)
    fprintf('Tmax (C): %2.4f\n',max(T))
    fprintf('Tmin (C): %2.4f\n',min(T))
    fprintf('Tmean (C): %2.4f\n',Tmean)
    fprintf('max. press. drop (Pa): %2.4f\n',p_drop*1e5)
    fprintf('max. dens. diff. (kg/m3): %2.4f\n',rho*beta*(max(T)-min(T)))
    if strcmp(p,'poiseuille-colebrook')
        fprintf('f: %2.4f (using Poiseuille-Colebrook)\n',f)
    elseif strcmp(p,'churchill')
        fprintf('f: %2.4f (using Churchill)\n',f)
    else
        fprintf('f: %2.4f\n',f)
    end
    fprintf('St: %2.4f\n',St)
    fprintf('Gr: %2.4e\n',Gr)
    fprintf('Gr*D/L: %2.4e\n',Gr*D/L)
    fprintf('Re: %2.4f\n',Re)
    fprintf('Ri_crit: %2.4f\n',Richardson_crit)
    fprintf('Ri: %2.4f\n',Richardson)
    fprintf('buoyancy: %2.4f\n',rho*beta*g*int_Tdz)
    fprintf('friction: %2.4f\n',(f*L/D+K)*w^2/(2*rho*A^2))
    fprintf('\n')
else
    disp('not converged:')
    if nit > nitmax
        disp('maximum number of iterations exceeded')
        fprintf('residue of energy balance: %2.4f\n',R_e)
    elseif Tmean >= Tsat
        disp('mean temperature reached saturation')
    end
end
print_current_time('simulation ended at ')
fprintf('---------------------------\n');