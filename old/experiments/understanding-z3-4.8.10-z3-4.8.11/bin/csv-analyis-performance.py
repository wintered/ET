import os
import sqlite3

def execute_sqlite_query_with_prefix(database_file, timeout):
    conn = sqlite3.connect(database_file)
    cursor = conn.cursor()
    query = f"select substr(solver_cfg, 1, 9), count(runtime) from ExpResults where (result='sat' or result='unsat') and runtime <= {timeout} and (solver_cfg like 'z3-before%' or solver_cfg like 'z3-after%') group by solver_cfg"
    cursor.execute(query)
    results = cursor.fetchall()
    conn.close()
    return results

def add_prefix_to_results(results, prefix):
    prefixed_results = [(prefix + row[0], row[1]) for row in results]
    return prefixed_results

print("timeout,theory,index,solver,count")
if __name__ == "__main__":
    results_folder = "results" 
    database_files = [file for file in os.listdir(results_folder) if file.endswith(".db")]
    timeouts=[0.03125,0.0625, 0.125,0.25,0.5,1,2,4,8]
    for db_file in database_files:
        database_path = os.path.join(results_folder, db_file)
        for timeout in timeouts:
            query_results = execute_sqlite_query_with_prefix(database_path, timeout)
            prefix = db_file.split("-")[0]+","+db_file.split("-")[1].split(".")[0] +","
            prefixed_results = add_prefix_to_results(query_results, prefix)
            for row in prefixed_results:
                print(str(timeout)+","+row[0] + "," + str(row[1]))

