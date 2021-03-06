function gen_gnuplot_file(arq,xlab,ylab,tit)

filename = [arq, '.gnu'];
fid = fopen(filename, 'w');

if nargin < 2
    xlab = '""';
    ylab = '""';
end
if nargin < 4
    tit = '""';
end

fprintf(fid,'reset\n');
fprintf(fid,'set term postscript landscape enhanced color solid "Helvetica" 16\n');
fprintf(fid,['set title ',tit,'\n']);
fprintf(fid,['set xlabel ',xlab,'\n']);
fprintf(fid,['set ylabel ',ylab,'\n']);
fprintf(fid,'set style fill transparent solid .8\n');
fprintf(fid,'set xrange[0:800]\n');
fprintf(fid,'set yrange[-5:20]\n');
fprintf(fid,'#set logscale x\n');
fprintf(fid,'#set logscale y\n');
fprintf(fid,'set key right top\n');
fprintf(fid,'set key spacing 1.5\n');
fprintf(fid,'set key box linewidth 1\n');
fprintf(fid,'set key textcolor rgbcolor "#000000"\n');
%% texts inside the plotting area
% fprintf(fid,'set label 1 "regiao instavel" at 310,450\n');
% fprintf(fid,'set label 2 "regiao instavel" at 310,1000\n');
% fprintf(fid,'set label 3 "regiao instavel" at 310,150\n');
% fprintf(fid,'set label 4 "regiao estavel" at 350,800\n');
%% grid
fprintf(fid,'set grid xtics lt 0 lw 1 lc rgb "#bbbbbb"\n');
fprintf(fid,'set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"\n');
% fprintf(fid,'set grid mxtics lt 0 lw 1 lc rgb "#bbbbbb"\n');
% fprintf(fid,'set grid mytics lt 0 lw 1 lc rgb "#bbbbbb"\n');
%%
fprintf(fid,['set output "../eps/',arq,'.eps"\n']);
if strcmp(arq,'CFL')
    fprintf(fid,['plot "../dat/',arq,'02.dat" title "CFL = 0.2" w lp lc 1 pt 0 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'04.dat" title "CFL = 0.4" w lp lc 7 pt 0 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'06.dat" title "CFL = 0.6" w lp lc 2 pt 0 lw 2\\\n']);
elseif strcmp(arq,'valid_NCL_boussinesq_01_269')
    fprintf(fid,['plot "../dat/',arq,'_exp.dat" title "experiment" w p lc 3 pt 5 ps 2 lw 0,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_p0316b02500.dat" title "numerical, {f = 0.316/Re^{0.2500}}" w lp lc 1 pt 7 ps 2 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_p2226b06744.dat" title "numerical, {f = 22.26/Re^{0.6744}}" w lp lc 2 pt 8 ps 2 lw 2\\\n']);
elseif strcmp(arq,'DT_heater_x_t')
    fprintf(fid,['plot "../dat/',arq,'_exp.dat" title "experimento" w l lc 3 lw 3,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_model.dat" title "modelo" w l lc 1 lw 3\\\n']);
elseif strcmp(arq,'DT_heater_x_t_CFL01')
    fprintf(fid,['plot "../dat/',arq,'.dat" title "modelo" w l lc 1 lw 3\\\n']);
elseif strcmp(arq,'RexGrDL')
    fprintf(fid,['plot "../dat/',arq,'_exp_hhhc.dat" title "HHHC - experiment" w p lc 3 pt 5 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_exp_hhvc.dat" title "HHVC - experiment" w p lc 1 pt 7 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_exp_vhhc.dat" title "VHHC - experiment" w p lc 2 pt 8 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_exp_vhvc.dat" title "VHVC - experiment" w p lc 4 pt 9 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_num_hhhc.dat" title "HHHC - model" w l lc 3 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_num_hhvc.dat" title "HHVC - model" w l lc 1 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_num_vhhc.dat" title "VHHC - model" w l lc 2 lw 2,\\\n']);
    fprintf(fid,['     "../dat/',arq,'_num_vhvc.dat" title "VHVC - model" w l lc 4 lw 2\\\n']);
else
    fprintf('gen_gnuplot_file: I have done nothing...\ncome here and check!\n')
end
fclose(fid);