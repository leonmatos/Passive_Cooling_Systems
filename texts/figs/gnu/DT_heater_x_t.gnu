reset
set term postscript landscape enhanced color solid "Helvetica" 16
set title ""
set xlabel "tempo [s]"
set ylabel "{/Symbol D}T [C]"
set style fill transparent solid .8
#set xrange[300:380]
#set yrange[-2:20]
#set logscale x
#set logscale y
set key right top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set grid xtics lt 0 lw 1 lc rgb "#bbbbbb"
set output "../eps/DT_heater_x_t.eps"
plot "../dat/DT_heater_x_t_exp.dat" title "experimento" w l lc 3 lw 3,\
     "../dat/DT_heater_x_t_model.dat" title "modelo" w l lc 1 lw 3\
