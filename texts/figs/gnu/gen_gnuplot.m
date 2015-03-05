% arq = 'DT_heater_x_t';
% gen_gnuplot_file(arq,'"tempo [s]"','"{/Symbol D}T [C]"','""');

% arq = 'DT_heater_x_t_CFL04';
% gen_gnuplot_file(arq,'"tempo [s]"','"{/Symbol D}T [C]"','""');

arq = 'DT_heater_x_t_CFL01';
gen_gnuplot_file(arq,'"tempo [s]"','"{/Symbol D}T [C]"','""');

% arq = 'RexGrDL';
% gen_gnuplot_file(arq,'"Gr_mD/L"','"Re"','""');

% arq = 'mxQ_sp';
% gen_gnuplot_file(arq,'"Power [kW]"','"Mass flow [kg/s]"','"(a)"');
% arq = 'mxQ_tp';
% gen_gnuplot_file(arq,'"Power [kW]"','"Mass flow [kg/s]"','"(a)"');
% arq = 'mxQ_sc';
% gen_gnuplot_file(arq,'"Power [kW]"','"Mass flow [kg/s]"','"(a)"');

% arq = 'estab_sp';
% gen_gnuplot_file(arq,'"St_m"','"Gr_m"','"(b)"');
% arq = 'estab_tp';
% gen_gnuplot_file(arq,'"subresfriamento [K]"','"carga termica [kW]"','"(b)"');
% arq = 'estab_sc';
% gen_gnuplot_file(arq,'"Temp. entrada aquecedor [C]"','"carga termica [kW]"','"(b)"');

%%
home
disp('generating gnu file...')
disp('done!')