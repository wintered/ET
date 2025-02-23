#! /opt/homebrew/bin/bash
tail +4 ../solvers.cfg|tac > .tmp
mapfile -t solvers < <(awk '{print $1}' .tmp)

for sol in "${solvers[@]}"
do
   for t in `ls results/*.db`; do
       theory=`echo $t |cut -d "/" -f 2`
       theory=`echo $theory|cut -d "." -f 1` 

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
mv csv/correctness_results.csv.tmp csv/correctness_results.csv
