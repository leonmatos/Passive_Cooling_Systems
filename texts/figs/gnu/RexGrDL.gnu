reset
set term postscript landscape enhanced color solid "Helvetica" 16
set title ""
set xlabel "Gr_mD/L"
set ylabel "Re"
set style fill transparent solid .8
set xrange[1e7:1e10]
set yrange[500:10000]
set logscale x
set logscale y
set key right bottom
set key spacing 1.5
set key box linewidth 1
set key textcolor rgbcolor "#000000"
set grid xtics lt 0 lw 1 lc rgb "#bbbbbb"
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set grid mxtics lt 0 lw 1 lc rgb "#bbbbbb"
set grid mytics lt 0 lw 1 lc rgb "#bbbbbb"
set output "../eps/RexGrDL.eps"
plot "../dat/RexGrDL_exp_hhhc.dat" title "HHHC - experiment" w p lc 3 pt 5 lw 2,\
     "../dat/RexGrDL_exp_hhvc.dat" title "HHVC - experiment" w p lc 1 pt 7 lw 2,\
     "../dat/RexGrDL_exp_vhhc.dat" title "VHHC - experiment" w p lc 2 pt 8 lw 2,\
     "../dat/RexGrDL_exp_vhvc.dat" title "VHVC - experiment" w p lc 4 pt 9 lw 2,\
     "../dat/RexGrDL_num_hhhc.dat" title "HHHC - model" w l lc 3 lw 2,\
     "../dat/RexGrDL_num_hhvc.dat" title "HHVC - model" w l lc 1 lw 2,\
     "../dat/RexGrDL_num_vhhc.dat" title "VHHC - model" w l lc 2 lw 2,\
     "../dat/RexGrDL_num_vhvc.dat" title "VHVC - model" w l lc 4 lw 2\
