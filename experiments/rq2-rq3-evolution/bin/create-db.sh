#! /bin/bash
if [ ! "$#" -eq 1 ]; then
    echo "Usage: $0 <theory>"
    exit 2
fi

touch $db

sqlite3 $db "CREATE TABLE ExpResults(
            formula_idx INTEGER,
            solver_cfg TEXT NOT NULL, 
            runtime DOUBLE NOT NULL,    
            result TEXT NOT NULL
)
"
i=0
for f in `find $result_dir/temp-$1 -name "*.time"`; do
    if ! ((i % 100)); then
        echo $i,$f
    fi
    tail -n +4 $f > $f.tmp
    sqlite3 $db -echo -cmd ".mode csv" ".import $f.tmp ExpResults"
    i=$((i+1))
done
