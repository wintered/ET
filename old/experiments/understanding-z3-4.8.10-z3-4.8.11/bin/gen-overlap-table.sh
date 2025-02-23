#! /bin/bash
theory=$1
db=results/$1.db
for cutoff in {0.03125,0.0625,0.125,0.25,0.5,1,2,4,8}; do
#for cutoff in {0.03125,0.0625}; do
    echo csv/overlap-z3-$theory-$cutoff.csv
    ./bin/get_overlap.sh "z3" $db $cutoff > csv/overlap-z3-$theory-$cutoff.csv
    echo csv/overlap-cvc-$theory-$cutoff.csv
    ./bin/get_overlap.sh "cvc" $db $cutoff > csv/overlap-cvc-$theory-$cutoff.csv
done
