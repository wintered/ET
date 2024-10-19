#! /bin/bash
declare -a solvers=("cvc5-1.0.5" "cvc5-1.0.4" "cvc5-1.0.3" "cvc5-1.0.2" "cvc5-1.0.1" "cvc5-1.0.0" "cvc5-0.0.12" "cvc5-0.0.11" "cvc5-0.0.10" "cvc5-0.0.8" "cvc5-0.0.7" "cvc5-0.0.6" "cvc5-0.0.5" "cvc5-0.0.4" "cvc5-0.0.3" "cvc5-0.0.2" "cvc4-1.8" "cvc4-1.7" "cvc4-1.6" "cvc4-1.5" "z3-4.12.1" "z3-4.12.0" "z3-4.11.2" "z3-4.11.0" "z3-4.10.2" "z3-4.10.1" "z3-4.10.0" "z3-4.9.1" "z3-4.9.0" "z3-4.8.17" "z3-4.8.16" "z3-4.8.15" "z3-4.8.14" "z3-4.8.13" "z3-4.8.12" "z3-4.8.11" "z3-4.8.10" "z3-4.8.9" "z3-4.8.8" "z3-4.8.7" "z3-4.8.6" "z3-4.8.5" "z3-4.8.4" "z3-4.8.3" "z3-4.8.1" "z3-4.7.1" "z3-4.6.0" "z3-4.5.0")
for sol in "${solvers[@]}"
do
   for t in `ls results/*-$1.db`; do
       theory=`echo $t |cut -d "/" -f 2`
       theory=`echo $theory|cut -d "." -f 1` 
       theory=`echo $theory |cut -d "-" -f 1`

       if [[ "$sol" == *"z3"* ]]; then
           family="Z3"
       else 
           family="CVC4/5"
       fi
       
       num_unsoundness=`sqlite3 $t "select count(*)from ExpResults where result='unsoundness' and solver_cfg like '%$sol%'"`
       num_invmodel=`sqlite3 $t "select count(*) from ExpResults where result='invmodel' and solver_cfg like '%$sol%'"`
       num_crash=`sqlite3 $t "select count(*) from ExpResults where result='crash' and solver_cfg like '%$sol%'"`

       echo $sol,$family,$theory,unsoundness,$num_unsoundness >> csv/correctness_results.csv
       echo $sol,$family,$theory,invalid model,$num_invmodel >> csv/correctness_results.csv
       echo $sol,$family,$theory,crash,$num_crash >> csv/correctness_results.csv
   done
done


echo "solver,family,theory,type,num_triggers" > csv/correctness_results.csv.tmp

# Exclude cvc4-1.5 and FloatingPoints (crash caused by incomplete implementation)
python3 -c 'print("\n".join([l for l in open("csv/correctness_results.csv").read().split("\n")[:-1] if not ("cvc4-1.5" in l and "FloatingPoints" in l)] + ["cvc4-1.5,CVC4/5,FloatingPoints,crash,0"]))' >> csv/correctness_results.csv.tmp
mv csv/correctness_results.csv.tmp csv/correctness_results-$1.csv
