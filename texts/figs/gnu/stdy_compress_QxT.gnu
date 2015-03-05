reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "Power [kW]"
set ylabel "Temperature [C]"
set style fill transparent solid .8
#set xrange[0.0:1.6]
#set yrange[0:0.3]
#set logscale x
set key left top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/stdy_compress_QxT.eps"
plot "../dat/stdy_compress_QxTin_N.dat" title "inlet - Nolsta model" w lp lc 3 pt 5 lw 2,\
     "../dat/stdy_compress_QxTout_N.dat" title "outlet - Nolsta model" w lp lc 3 pt 4 lw 2,\
     "../dat/stdy_compress_QxTin_E.dat" title "inlet - experiment" w lp lc 1 pt 5 lw 2,\
     "../dat/stdy_compress_QxTout_E.dat" title "outlet - experiment" w lp lc 1 pt 4 lw 2,\
     "../dat/stdy_compress_QxTin_U.dat" title "inlet - this model" w lp lc 2 pt 5 lw 2,\
     "../dat/stdy_compress_QxTout_U.dat" title "outlet - this model" w lp lc 2 pt 4 lw 2\
