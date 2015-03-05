reset
set term postscript landscape enhanced color solid "Helvetica" 20
set title "(a)"
set xlabel "Power [kW]"
set ylabel "Mass flow [kg/s]"
set style fill transparent solid .8
#set xrange[300:380]
#set yrange[0:0.018]
#set logscale y
set key right bottom
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/mxQ_sp.eps"
plot "../dat/mxQ_sp_280.dat" title "D = 28.0 mm" w lp lc 3 pt 5 ps 1 lw 2,\
     "../dat/mxQ_sp_207.dat" title "D = 20.7 mm" w lp lc 1 pt 7 ps 1 lw 2,\
     "../dat/mxQ_sp_140.dat" title "D = 14.0 mm" w lp lc 2 pt 8 ps 1 lw 2\
