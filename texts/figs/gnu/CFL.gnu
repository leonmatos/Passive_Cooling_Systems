reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "time (s)"
set ylabel "W/W_{ss}"
set style fill transparent solid .8
#set xrange[0.0:1.6]
#set yrange[0:0.3]
#set logscale x
set key right top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/CFL.eps"
plot "../dat/CFL02.dat" title "CFL = 0.2" w lp lc 1 pt 0 lw 2,\
     "../dat/CFL04.dat" title "CFL = 0.4" w lp lc 7 pt 0 lw 2,\
     "../dat/CFL06.dat" title "CFL = 0.6" w lp lc 2 pt 0 lw 2\
