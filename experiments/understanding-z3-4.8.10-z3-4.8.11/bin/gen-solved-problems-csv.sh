#! /bin/bash
rm -rf .*.tmp
declare -a timeouts=(0.03125 0.0625 0.125 0.25 0.5 1 2 4 8)

for timeout in "${timeouts[@]}"; do
    echo t=$timeout
    for t in `ls results/*-$1.db`; do
        theory=`echo $t |cut -d "/" -f 2`
        theory=`echo $theory|cut -d "." -f 1`
        theory=`echo $theory |cut -d "-" -f 1`

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
    rm -rf csv/solved-problems-$timeout-$1.csv
    touch csv/solved-problems-$timeout-$1.csv
    echo "solver,result,count,theory,family" >> csv/solved-problems-$timeout-$1.csv
    cat .$timeout-*-styled.tmp >> csv/solved-problems-$timeout-$1.csv
done
rm -rf .*.tmp
