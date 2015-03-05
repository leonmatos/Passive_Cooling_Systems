reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "Power [kW]"
set ylabel "Mass flow [kg/s]"
set style fill transparent solid .8
set xrange[0:2.6]
set yrange[0:0.018]
#set logscale x
set key right bottom
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/valid_NCL_boussinesq_01_140.eps"
plot "../dat/valid_NCL_boussinesq_01_140_exp.dat" title "experiment" w p lc 3 pt 5 ps 2 lw 0,\
     "../dat/valid_NCL_boussinesq_01_140_Ts15.dat" title "numerical, {T_s} = 15 C" w lp lc 1 pt 7 ps 2 lw 2,\
     "../dat/valid_NCL_boussinesq_01_140_Ts30.dat" title "numerical, {T_s} = 30 C" w lp lc 2 pt 8 ps 2 lw 2\
