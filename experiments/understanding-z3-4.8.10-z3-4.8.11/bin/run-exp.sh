##! /bin/bash
if [ ! "$#" -eq 7 ]; then
    echo "Usage: $0 <theory> <start_idx> <num_tests> <num_iterations> <num_cores> <timeout> <memout>"
    exit 2
fi

theory=$1
start_idx=$2
num_tests=$3
num_iterations=$4
num_cores=$5
timeout=$6
memout=$7

for i in `seq $num_iterations`; do
    rm -rf results/temp-$theory-$i
    mkdir -p results/temp-$theory-$i results/bugs-$theory-$i
    # Generate all tests
    bin/${theory}5-large-enum $start_idx $num_tests results/temp-$theory-$i

    # Execute SMT solvers
    find results/temp-$theory-$i -name "*.smt2" -print0|\
    parallel -0 -j${num_cores} --eta --progress --bar ../../bin/oracle.py {} {}.time solver_cfgs results/bugs-$theory-$i $timeout $memout   
    start_idx=$((start_idx + 5))
done
