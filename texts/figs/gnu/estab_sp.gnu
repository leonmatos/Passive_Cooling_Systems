reset
set term postscript landscape enhanced color solid "Helvetica" 20
set title "(b)"
set xlabel "St_m"
set ylabel "Gr_m"
set style fill transparent solid .8
set xrange[0:12]
#set yrange[0:0.018]
set logscale y
set key right bottom
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set label 1 "regiao instavel" at 2,1e+18
set label 2 "regiao estavel" at 8,1e+30
set output "../eps/estab_sp.eps"
plot "../dat/estab_sp_280.dat" title "D = 28.0 mm" w lp lc 3 pt 5 lw 2,\
     "../dat/estab_sp_207.dat" title "D = 20.7 mm" w lp lc 1 pt 7 lw 2,\
     "../dat/estab_sp_140.dat" title "D = 14.0 mm" w lp lc 2 pt 8 lw 2\
