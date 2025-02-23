#! /bin/bash
#
rm -rf *.tmp
echo "solver,throughput,theory,family" > csv/throughput-$1.csv 
for t in `ls results/*-${1}.db`; do
   theory=`echo $t |cut -d "/" -f 2`
   theory=`echo $theory|cut -d "." -f 1`
   theory=`echo $theory |cut -d "-" -f 1`

   sqlite3 $t ".separator ," "select solver_cfg, count(runtime) / sum(runtime)  from ExpResults where result='sat' or result='unsat' group by solver_cfg" >> .throughput-$theory-$1.tmp
    python3 bin/helper-solved-problems.py .throughput-$theory-$1.tmp >> csv/throughput-$1.csv 
done
rm -rf .*.tmp
