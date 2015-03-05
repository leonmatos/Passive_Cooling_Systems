reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "Power [kW]"
set ylabel "Mass flow [kg/s]"
set style fill transparent solid .8
#set xrange[0.0:1.6]
#set yrange[0:0.3]
#set logscale x
set key left top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/stdy_compress_Qxm.eps"
plot "../dat/stdy_compress_Qxm_N.dat" title "Nolsta model" w lp lc 3 pt 5 lw 2,\
     "../dat/stdy_compress_Qxm_E.dat" title "experiment" w lp lc 1 pt 7 lw 2,\
     "../dat/stdy_compress_Qxm_U.dat" title "this model" w lp lc 2 pt 8 lw 2\
