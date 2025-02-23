##! /bin/bash
if [ ! "$#" -eq 5 ]; then
    echo "Usage: $0 <theory> <num_tests> <num_cores> <timeout> <memout>"
    exit 2
fi

theory=$1
num_tests=$2
result_dir="results"

rm -rf $result_dir/temp-$theory
mkdir -p $result_dir/temp-$theory $result_dir/bugs-$theory

# Generate all tests
../../bin/feat-$theory $num_tests $result_dir/temp-$theory

num_cores=$3
timeout=$4
memout=$5

# Execute SMT solvers
find $result_dir/temp-$theory -name "*.smt2" -print0|\
parallel -0 -j${num_cores} --eta --progress --bar ../../bin/oracle {} {}.time ../solvers.cfg $result_dir/bugs-$theory $timeout $memout    
