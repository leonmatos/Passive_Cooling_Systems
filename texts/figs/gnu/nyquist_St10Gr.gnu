reset
set term postscript landscape enhanced color solid "Helvetica" 18
set title ""
set xlabel "Real(Y)"
set ylabel "Imag(Y)"
set style fill transparent solid .8
#set xrange[0.0:1.6]
#set yrange[0:0.3]
#set logscale x
set key right top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set output "../eps/nyquist_St10Gr.eps"
plot "../dat/nyquist_St10Gr8e11.dat" title "St = 10; Gr = 8e11" w lp lc 1 pt 0 lw 2,\
     "../dat/nyquist_St10Gr3e12.dat" title "St = 10; Gr = 3e12" w lp lc 3 pt 0 lw 2\
