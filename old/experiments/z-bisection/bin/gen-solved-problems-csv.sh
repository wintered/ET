#! /bin/bash
rm -rf .*.tmp
declare -a timeouts=(0.03125 0.0625)
for timeout in "${timeouts[@]}"; do
    echo t=$timeout
    for t in `ls results/*.db`; do
        theory=`echo $t |cut -d "/" -f 2`
        theory=`echo $theory|cut -d "." -f 1`
        echo $theory 
        touch .$timeout-$theory.tmp

       sqlite3 $t ".separator ," "select solver_cfg,result,count(runtime) from ExpResults where result='sat' and runtime <= $timeout group by solver_cfg " >> .$timeout-$theory.tmp
       sqlite3 $t ".separator ," "select solver_cfg,result,count(runtime) from ExpResults where result='unsat' and runtime <= $timeout group by solver_cfg " >> .$timeout-$theory.tmp
       sqlite3 $t ".separator ," "select solver_cfg,result,count(runtime) from ExpResults where result='unknown' and runtime <= $timeout group by solver_cfg ">> .$timeout-$theory.tmp
        python3 bin/helper-solved-problems.py .$timeout-$theory.tmp > .$timeout-$theory-styled.tmp
    done
    echo "" 
done

for timeout in "${timeouts[@]}"; do
    rm -rf csv/solved-problems-$timeout.csv
    touch csv/solved-problems-$timeout.csv
    echo "solver,result,count,theory,family" >> csv/solved-problems-$timeout.csv
    cat .$timeout-*-styled.tmp >> csv/solved-problems-$timeout.csv
done
rm -rf .*.tmp
