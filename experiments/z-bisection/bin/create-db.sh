#! /bin/bash
if [ ! "$#" -eq 1 ]; then
    echo "Usage: $0 <theory>"
    exit 2
fi

db=results/$1.db
rm -rf $db
touch $db 

sqlite3 $db "CREATE TABLE ExpResults(
            formula_idx INTEGER,
            solver_cfg TEXT NOT NULL, 
            runtime DOUBLE NOT NULL,    
            result TEXT NOT NULL
)
"
i=0
for f in `find results/temp-$1 -name "*.time"`; do
    if ! ((i % 100)); then
        echo $i,$f
    fi
    sqlite3 $db -echo -cmd ".mode csv" ".import $f ExpResults"
    i=$((i+1))
done
