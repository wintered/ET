#! /bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: ./get_overlap.sh <family> <db> <cutoff>"
    exit 1
fi
family=$1
db=$2
cutoff=$3
if [[ "$family" == *"z3"* ]]; then
    solvers=("z3-4.5.0" "z3-4.6.0" "z3-4.7.1" "z3-4.8.1" "z3-4.8.3" "z3-4.8.4" "z3-4.8.5" "z3-4.8.6" "z3-4.8.7" "z3-4.8.8" "z3-4.8.9" "z3-4.8.10" "z3-4.8.11" "z3-4.8.12" "z3-4.8.13" "z3-4.8.14" "z3-4.8.15" "z3-4.8.16" "z3-4.8.17" "z3-4.9.0" "z3-4.9.1" "z3-4.10.0" "z3-4.10.1" "z3-4.10.2" "z3-4.11.0" "z3-4.11.2" "z3-4.12.0" "z3-4.12.1")
elif  [[ "$family" == *"cvc"* ]]; then
    solvers=("cvc4-1.5" "cvc4-1.6" "cvc4-1.7" "cvc4-1.8" "cvc5-0.0.2" "cvc5-0.0.3" "cvc5-0.0.4" "cvc5-0.0.5" "cvc5-0.0.6" "cvc5-0.0.7" "cvc5-0.0.8" "cvc5-0.0.10" "cvc5-0.0.11" "cvc5-0.0.12" "cvc5-1.0.0" "cvc5-1.0.1" "cvc5-1.0.2" "cvc5-1.0.3" "cvc5-1.0.4", "cvc5-1.0.5")
fi

echo "solver1,solver2,+,0,-"
for i in `seq 0 $((${#solvers[@]}-2))`; do
    solver1=${solvers[i]}
    solver2=${solvers[$((i+1))]}

    sqlite3 $db "drop view if exists Solver1"
    sqlite3 $db "drop view if exists Solver2"
    sqlite3 $db "create view Solver1 as select * from ExpResults where solver_cfg like '%$solver1%' and result like '%sat%' and runtime <= $cutoff" 
    sqlite3 $db "create view Solver2 as select * from ExpResults where solver_cfg like '%$solver2%' and result like '%sat%' and runtime <= $cutoff" 
    plus=`sqlite3 $db "select count(Solver1.formula_idx) from Solver1 where not exists (select * from Solver2 where Solver1.formula_idx = Solver2.formula_idx)"`

    zero=`sqlite3 $db "select count(Solver2.formula_idx) from Solver2 where exists (select * from Solver1 where Solver1.formula_idx = Solver2.formula_idx)"`

    minus=`sqlite3 $db "select count(Solver2.formula_idx) from Solver2 where not exists (select * from Solver1 where Solver1.formula_idx = Solver2.formula_idx)"`

    echo ${solvers[i]},${solvers[$((i+1))]},$plus,$zero,$minus
done
