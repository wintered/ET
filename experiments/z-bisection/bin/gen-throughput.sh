#! /bin/bash
#
rm -rf *.tmp
echo "solver,throughput,theory,family" > csv/throughput.csv 
for t in `ls results/*.db`; do
   theory=`echo $t |cut -d "/" -f 2`
   theory=`echo $theory|cut -d "." -f 1`
   sqlite3 $t ".separator ," "select solver_cfg, count(runtime) / sum(runtime)  from ExpResults where result='sat' or result='unsat' group by solver_cfg" >> .throughput-$theory.tmp
    python3 bin/helper-solved-problems.py .throughput-$theory.tmp >> csv/throughput.csv 
done
rm -rf *.tmp
