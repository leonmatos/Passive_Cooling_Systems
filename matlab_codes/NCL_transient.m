function [d,w_output,t_output] = NCL_transient(input_var,in1,in2,s,z,ds,L,H,Lh,D,K,...
    sh_in,sh_out,sc_in,sc_out,p,b,f,rho,beta,cp,p0,wt,T,Ts,perturbation,...
    CFL,advance_scheme,tmax,update,n_oscil_max,show_plots)
disp('TRANSIENT CALCULATION')
if isnan(wt)
    disp('calculation aborted: NaN input mass flow')
    d = nan;
    return
end
if strcmp(input_var,'St-Gr')
    St = in1;
    Gr = in2;
elseif strcmp(input_var,'Q-U')
    Q = in1;
    U = in2;
else
    disp('first input argument is wrong!!!')
end
W = .5*(L-2*H);
%% calculation of physical and geometric parameters
conv_criterion = 1e-3;
n_pert = 1; % number of times the steady state is perturbed
zh_in = z(s == sh_in);
zh_out = z(s == sh_out);
zc_in = z(s == sc_in);
zc_out = z(s == sc_out);
DH = (zc_in + zc_out)/2-(zh_in + zh_out)/2;
A = .25*pi*D^2;
u = wt/rho/A;
g = 9.81; % gravity acceleration (m/s2)
Tsat = XSteam('Tsat_p',p0);
mu = XSteam('my_pT',p0,mean(T));
dt = CFL*ds/u;%dt = .1;
Re = 4*wt/pi/D/mu;
if strcmp(input_var,'Q-U')
    Gr = D^3*rho^2*beta*g*Q*DH/(mu^3*A*cp);
    St = 4*U*L/(mu*Re*cp);
else
    Q = Gr*mu^3*A*cp/(D^3*rho^2*beta*g*DH);
    U = St*mu*Re*cp/(4*L);
end
%% initialization
print_current_time('simulation started at ')
%
disp([advance_scheme,' scheme'])
fprintf('dt (s): %2.4f\n',dt)
nt = round(tmax/dt);
t = linspace(0,tmax,nt);
w = 0*t+nan;
Tp = T;
signal = 1;
wmax = zeros(1,round(nt/10))*nan;
wmin = zeros(1,round(nt/10))*nan;
wextreme = zeros(1,round(nt/5))*nan;
ti = zeros(1,round(nt/5))*nan;
kmin = 0;
kmax = 0;
i_minus = 0;
jh_in = find(s == sh_in);
jh_out = find(s == sh_out);
jc_in = find(s == sc_in);
jc_out = find(s == sc_out);
fprintf('imposing perturbation of %2.0f',perturbation)
disp('%')
wt = wt*(1+perturbation/100);
si = linspace(0,max(s),40);
row_T = 0;
reversed = 0;
for i = 2:nt
    %% calculation
    if strcmp(advance_scheme,'explicit')
        T = calcula_T_explicit(Tp,wt,rho,cp,D,Q,Lh,U,Ts,ds,dt,sh_in,sh_out,sc_in,sc_out,s);
    else
        T = calcula_T_implicit(Tp,wt,rho,cp,D,Q,Lh,U,Ts,ds,dt,sh_in,sh_out,sc_in,sc_out,s);
    end
    Tp = T;
    Tmean = mean(T);
    Tmax = max(T);
    Tmin = min(T);
    int_Tdz = integra_T(T,z);
    wp = wt;
    wt = calcula_w(wt,L,D,K,f,rho,beta,int_Tdz,dt);
    %% data storage
        output = wt;
        text_ylabel = 'mass flow [kg/s]';
%     output = (1-2*reversed)*(T(jh_out)-T(jh_in));
%     text_ylabel = 'heater temperature difference [K]';
    if i <= length(w)
        w(i) = output;
    else
        w(1:end-1) = w(2:end);
        w(end) = output;
        i_minus = i-nt;
        t(1:end-1) = t(2:end);
        t(end) = t(end)+dt;
    end
    if sign(w(i-i_minus)-w(i-i_minus-1))*signal < 0
        if signal > 0
            kmax = kmax + 1;
            wmax(kmax) = w(i-i_minus-1);
        else
            kmin = kmin + 1;
            wmin(kmin) = w(i-i_minus-1);
        end
        wextreme(kmax+kmin) = w(i-i_minus-1);
        ti(kmax+kmin) = t(i-i_minus-1);
        signal = -1*signal;
    end
    %% reversal
    if sign(wt*wp) < 0
        reversed = 1 - reversed;
        T = T(end:-1:1);
        Tp = Tp(end:-1:1);
        smax = max(s);
        s = smax - s(end:-1:1);
        z = z(end:-1:1);
        swp = smax - sh_in;
        sh_in = smax - sh_out;
        sh_out = swp;
        swp = smax - sc_in;
        sc_in = smax - sc_out;
        sc_out = swp;
        swp = zh_in;
        zh_in = zh_out;
        zh_out = swp;
        swp = zc_in;
        zc_in = zc_out;
        zc_out = swp;
        jh_in = find(s == sh_in);
        jh_out = find(s == sh_out);
        jc_in = find(s == sc_in);
        jc_out = find(s == sc_out);
    end
    %% stoping criteria
    if Tmax > Tsat
        fprintf('\n!!  BOILING  !!\n')
        fprintf('Tsat = %3.2f C\n',Tsat)
        figure(2),plot(s,T),xlabel('loop coordinate [m]'),ylabel('temperature [C]')
        break
    end
    if kmax > 1 && kmin > 1
        if (.5*(wmax(kmax)+wmax(kmax-1)) - .5*(wmin(kmin)+wmin(kmin-1)))/(max(wmax)-min(wmin)) < conv_criterion...
                || kmax > n_oscil_max
            break
        end
    end
    %% recalculation of physical parameters
    if update
        beta = calcula_beta(p0,Tmean);
        mu = XSteam('my_pT',p0,Tmean);
        cp = XSteam('cp_pT',p0,Tmean);
        rho = XSteam('rho_pT',p0,Tmean);
        Re = 4*abs(wt)/pi/D/mu;
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
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if show_plots
    if n_pert > 0
        hfig = figure(1);
        set(hfig, 'Position', [300 100 600 400]);
        w(isnan(w)) = [];
        t = 0:dt:((length(w)-1)*dt);
        plot(t,real(w),'r','LineWidth',2)
        xlabel('time [s]'),ylabel(text_ylabel),grid on
        drawnow
    end
end
t_output = linspace(min(t),max(t),100)';
w_output = interp1(t,w,t_output);
%% calculando taxa de crescimento/decaimento
fprintf('\n');
if length(wmax(3:kmax)) >= n_oscil_max-1 && i < nt
    amplitude = wmax(3:kmin-1) - wmin(3:kmin-1);
    c = exp_regression(1:length(amplitude),amplitude,'no_plot');
    d = exp(c(1));
    %     d = zeros(length(amplitude)-1,1);
    %     for i = 2:length(amplitude)
    %         d(i) = amplitude(i)/amplitude(i-1);
    %     end
    %     d = mean(d);
    %     d = d(end);
    tmax = t(w == wmin(kmin));
    tmin = t(w == wmin(3));
    period = (tmax(1)-tmin(1))/(kmin-3);
    fprintf('\nperiod of oscillations (s): %2.2f\n',period)
    fprintf('number of oscillations: %d\n',kmin)
    if abs(d) < .99
        fprintf('decay ratio: %2.6f\nsystem is stable\n\n',d)
    elseif d > 1.01
        fprintf('increase ratio: %2.6f\nsystem is unstable\n\n',d)
    else
        fprintf('increase ratio: %2.6f\nsystem is neutrally stable\n\n',d)
    end
elseif i < nt
    if kmin > 3
        amplitude = zeros(1,min(kmax,kmin));
        amplitude = wmax(1:length(amplitude)) - wmin(1:length(amplitude));
        c = exp_regression(1:(length(amplitude)-1),amplitude(2:end),'no_plot');
        d = exp(c(1));
        %         d = zeros(length(amplitude)-2,1);
        %         for i = 3:length(amplitude)
        %             d(i) = amplitude(i)/amplitude(i-1);
        %         end
        %         d = mean(d);
        %             d = d(end);
        tmax = t(w == wmin(min(kmax,kmin)));
        tmin = t(w == wmin(2));
        period = (tmax(1)-tmin(1))/(min(kmax,kmin)-2);
        fprintf('\nperiod of oscillations (s): %2.2f\n',period)
        fprintf('number of oscillations: %d\n',kmin)
        if abs(d) < .99
            fprintf('decay ratio: %2.6f\nsystem is stable\n\n',d)
        elseif d > 1.01
            fprintf('increase ratio: %2.6f\nsystem is unstable\n\n',d)
        else
            fprintf('increase ratio: %2.6f\nsystem is neutrally stable\n\n',d)
        end
    else
        d = nan;
        fprintf('cant make conclusion about stability!\n\n')
    end
else
    if kmin >= 6
        amplitude = wmax(kmin-5:kmin)-wmin(kmin-5:kmin);
        c = exp_regression(1:length(amplitude),amplitude,'no_plot');
        d = exp(c(1));
        %         d = zeros(length(amplitude)-1,1);
        %         for i = 2:length(amplitude)
        %             d(i) = amplitude(i)/amplitude(i-1);
        %         end
        %         d = mean(d);
        %             d = d(end);
        tmax = t(w == wmin(kmin));
        tmin = t(w == wmin(kmin-5));
        period = (tmax(1)-tmin(1))/(min(kmax,kmin)-2);
        fprintf('\nperiod of oscillations (s): %2.2f\n',period)
        fprintf('number of oscillations: %d\n',kmin)
        if abs(d) < .99
            fprintf('decay ratio: %2.6f\nsystem is stable\n\n',d)
        elseif d > 1.01
            fprintf('increase ratio: %2.6f\nsystem is unstable\n\n',d)
        else
            fprintf('increase ratio: %2.6f\nsystem is neutrally stable\n\n',d)
        end
    else
        d = nan;
        fprintf('cant make conclusion about stability!\n\n')
    end
end
print_current_time('simulation ended at ')
fprintf('---------------------------\n');