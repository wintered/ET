#! /bin/bash
#
rm -rf *.tmp
echo "solver,cumulative_time,theory,family" > csv/cumulative_time.csv 
for t in `ls results/*.db`; do
   theory=`echo $t |cut -d "/" -f 2`
   theory=`echo $theory|cut -d "." -f 1`
    sqlite3 $t ".separator ," "select solver_cfg,sum(runtime) from ExpResults where result='sat' or result='unsat' group by solver_cfg" >> .cumulative_time-$theory.tmp
    python3 bin/helper-solved-problems.py .cumulative_time-$theory.tmp >> csv/cumulative_time.csv 
done
rm -rf *.tmp
