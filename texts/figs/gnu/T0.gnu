reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "position in the loop (m)"
set ylabel "temperature (C)"
set style fill transparent solid .8
#set xrange[0.0:1.6]
#set yrange[0:0.3]
#set logscale x
set key right top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/T0.eps"
plot "../dat/T0_10.dat" title "{T_0} = 10 C" w lp lc 1 pt 0 lw 4,\
     "../dat/T0_30.dat" title "{T_0} = 30 C" w lp lc 2 pt 0 lw 4,\
     "../dat/T0_50.dat" title "{T_0} = 50 C" w lp lc 3 pt 0 lw 4,\
     "../dat/T0_70.dat" title "{T_0} = 70 C" w lp lc 4 pt 0 lw 4\
