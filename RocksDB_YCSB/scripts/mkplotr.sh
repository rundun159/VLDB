#!/usr/bin/gnuplot

set terminal png size 800, 570 enhanced font "Helvetical, 13"
set output 'all_multi_ORG.png'

set grid
set key right bot
set xlabel "Time (sec)"
set ylabel "WAF"
set y2label "ops/sec (x1,000)"
#set yrange[1:1.3]
#set y2range[0:10]
#set xrange[0:4800]

set ytics nomirror
set y2tics 

set style line 1 linewidth 3 pointtype 1 pointsize 10 lc rgb "blue"
set style line 2 linewidth 3 pointtype 1 pointsize 10 lc rgb "red"
set style line 3 linewidth 3 pointtype 1 pointsize 10 lc rgb "purple"
set style line 4 linewidth 3 pointtype 1 pointsize 10 lc rgb "pink"
set style line 5 linewidth 3 pointtype 1 pointsize 10 lc rgb "cyan" 
set style line 6 linewidth 3 pointtype 1 pointsize 10 lc rgb "violet"
set style line 7 linewidth 3 pointtype 1 pointsize 10 lc rgb "orange" 
set style line 8 linewidth 3 pointtype 1 pointsize 10 lc rgb "black"


plot \
  "cum_waf" using ($1):2 title "WAF" with lines linestyle 2,\
  "rocksdb_run.txt" using ($3):($7/1000) smooth bezier title "OPS (1thread)" with lines linestyle 3 axes x1y2,\
#  "rocksdb_run2.txt" using ($3):($7/1000) smooth bezier title "OPS (1thread)" with lines linestyle 4 axes x1y2

#  "rocksdb_run3.txt" using ($3):($7/1000) smooth bezier title "OPS (1thread)" with lines linestyle 5 axes x1y2,\
#  "rocksdb_run4.txt" using ($3):($7/1000) smooth bezier title "OPS (1thread)" with lines linestyle 6 axes x1y2

#  "run_waf" using ($1/3600):2 title "WAF" with lines linestyle 2,\
#  "rocksdb_run.log" using ($3/3600):($7*4) smooth bezier title "OPS (1thread)" with lines linestyle 5 axes x1y2,\




#	"./140/run_waf" using ($1):2 title "Ext4 - 140" with lines linestyle 5,\
#	"../run_waf" using ($1):2 title "Ext4 - 150" with lines linestyle 6,\
#	"./150/ori_run" using ($1):2 title "Ext4 - new" with lines linestyle 3,\
#	"ALOCK-VER/run_waf_origin" using ($1):2 title "1 instance WAF" with lines linestyle 4,\
#	"ALOCK-VER/origin_run.log" using ($3):($7) smooth bezier title "1 instance OPS" with lines linestyle 7 axes x1y2

#"write-stall.log" using 3:($7)  title "OPS" with lines linestyle 8 axes x1y1,\


#	"dirty.log" using ($0*10):1 title "DB Size" with lines linestyle 2 axes x1y2,\
#	"run_waf2" using ($1):2 smooth bezier title "1thread smooth WAF" with lines linestyle 2,\
#	"run_waf3" using ($1):2 smooth bezier title "16thread smooth WAF" with lines linestyle 3,\
#	"run_waf" using ($1):2 smooth bezier title "f2fs smooth WAF" with lines linestyle 4,\
#"run_2inst_ori_150_run_smart.log" using ($1):2 title "buf WAF" with lines linestyle 3,\
#	"run_2inst_dio_run_smart.log" using ($1):2 title "16M WAF" with lines linestyle 4,\
#	"run_2inst_32M_run_smart.log" using ($1):2 title "32M WAF" with lines linestyle 5,\
