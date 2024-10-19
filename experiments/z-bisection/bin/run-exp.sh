##! /bin/bash
if [ ! "$#" -eq 5 ]; then
    echo "Usage: $0 <theory> <num_tests> <num_cores> <timeout> <memout>"
    exit 2
fi

theory=$1
num_tests=$2

rm -rf results/temp-$theory
mkdir -p results/temp-$theory results/bugs-$theory

# Generate all tests
../../bin/feat-$theory $num_tests results/temp-$theory

num_cores=$3
timeout=$4
memout=$5

# Execute SMT solvers
solver_cfg="../../1_correctness_performance/solver_cfgs"
find results/temp-$theory -name "*.smt2" -print0|\
parallel -0 -j${num_cores} --eta --progress --bar ../../bin/oracle.py {} {}.time $solver_cfgs results/bugs-$theory $timeout $memout    
