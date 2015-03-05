reset
set term postscript landscape enhanced color solid "Helvetica" 20
set title "(b)"
set xlabel "subresfriamento [K]"
set ylabel "carga termica [kW]"
set style fill transparent solid .8
set xrange[5:35]
#set yrange[0:0.018]
#set logscale y
set key right bottom
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set label 1 "regiao estavel" at 6,7
set label 2 "regiao estavel" at 6,30
set label 3 "regiao estavel" at 6,70
set label 4 "regiao instavel" at 27,50
set output "../eps/estab_tp.eps"
plot "../dat/estab_tp_200.dat" title "D = 20.0 mm" w lp lc 3 pt 5 lw 2,\
     "../dat/estab_tp_150.dat" title "D = 15.0 mm" w lp lc 1 pt 7 lw 2,\
     "../dat/estab_tp_100.dat" title "D = 10.0 mm" w lp lc 2 pt 8 lw 2\
