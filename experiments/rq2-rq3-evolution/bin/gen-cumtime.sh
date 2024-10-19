#! /bin/bash
set -x
echo "solver,family,theory,cumulative_time" > csv/cumulative_time.csv
for db in `ls results/*.db`; do
    num_solver=`sqlite3 $db "SELECT count(distinct(solver_cfg)) from ExpResults"`

    sqlite3 $db "drop view if exists Decided"
    sqlite3 $db "drop view if exists DecidedSolvingCounts"
    sqlite3 $db "drop view if exists CommonlyDecided"
    sqlite3 $db "create view Decided as select * from ExpResults where result='sat' or result='unsat'"
    sqlite3 $db "create view DecidedSolvingCounts as select formula_idx,count(*) as solving_count from Decided group by formula_idx"
    sqlite3 $db "create view CommonlyDecided as Select * from Decided where
                not exists
                (select * from DecidedSolvingCounts where Decided.formula_idx = DecidedSolvingCounts.formula_idx and
                DecidedSolvingCounts.solving_count != $num_solver)"

    sqlite3 $db "select solver_cfg,sum(runtime) from CommonlyDecided group by solver_cfg" > res.txt
    theory=`basename $db`
    #pycode='print("\n".join([l.split(" ")[0]+ "Z3" if z3 in l else "CVC4/5" if  ",'${theory//.db/},'" +l.split("|")[1].strip() for l in open("res.txt").readlines()]))'
    pycode='print("\n".join([l.split(" ")[0]+  (",Z3," if "z3" in l else ",CVC4/5,")  +  "'${theory//.db/},'" +l.split("|")[1].strip() for l in open("res.txt").readlines()]))'
    python3 -c "$pycode" >> csv/cumulative_time.csv
done

