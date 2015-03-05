% function d = NCL_main(in1)
clear,home
path('../../../matlab_lib/XSteam_Matlab_v2.6',path)
path('../../../matlab_lib',path)
%% INPUTS
% input_var = 'St-Gr';
% in1 = 10;
% in2 = 1.18e10;
input_var = 'Q-U';
in1 = .4; % kW
in2 = 4; % kW/m2/K
% [s,z,ds,L,Lh,H,D,K,sh_in,sh_out,sc_in,sc_out] = NCL_geometry('last_geom_data.dat');
[s,z,ds,L,Lh,H,D,K,sh_in,sh_out,sc_in,sc_out] = NCL_geometry();
show_plots = 1;
p = 'poiseuille-colebrook';
% p = 'churchill';
% p = 22.26; % p and b are constants for f = p/Re^b;
b = .6744;
p0 = 1; % circuit pressure (bar)
uini = 4; % initial velocity (m/s)
Ts = 30; % secondary side circuit temperature (C)
perturbation = -100; % perturbation (in %)
CFL = .4; % Courant-Friedrichs-Lewy
tmax = 2000;
update = 1;
n_oscil_max = 1000; % number of oscillations when simulation is stopped
%%
[f,rho,beta,cp,w,T,Re,St,Gr] = NCL_steady_state(input_var,in1,in2,s,z,ds,L,Lh,H,D,K,...
    sh_in,sh_out,sc_in,sc_out,p,b,p0,uini,Ts,'implicit');
% return

[d,w,t] = NCL_transient(input_var,in1,in2,s,z,ds,L,H,Lh,D,K,...
    sh_in,sh_out,sc_in,sc_out,p,b,f,rho,beta,cp,p0,w,T,Ts,perturbation,...
    CFL,'explicit',tmax,update,n_oscil_max,show_plots);