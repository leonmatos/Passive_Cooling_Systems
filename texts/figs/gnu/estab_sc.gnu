reset
set term postscript landscape enhanced color solid "Helvetica" 20
set title "(b)"
set xlabel "Temp. entrada aquecedor [C]"
set ylabel "carga termica [kW]"
set style fill transparent solid .8
set xrange[300:380]
#set yrange[0:0.018]
#set logscale y
set key right top
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set label 1 "regiao instavel" at 310,450
set label 2 "regiao instavel" at 310,1000
set label 3 "regiao instavel" at 310,150
set label 4 "regiao estavel" at 350,800
set output "../eps/estab_sc.eps"
plot "../dat/estab_sc_280.dat" title "D = 28.0 mm" w lp lc 3 pt 5 lw 2,\
     "../dat/estab_sc_207.dat" title "D = 20.7 mm" w lp lc 1 pt 7 lw 2,\
     "../dat/estab_sc_140.dat" title "D = 14.0 mm" w lp lc 2 pt 8 lw 2\
