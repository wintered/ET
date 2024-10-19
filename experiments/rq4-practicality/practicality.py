import sqlite3
import numpy as np
import pandas as pd
import multiprocessing
from datetime import datetime, timedelta

def distinct_groups(cursor, formula_idx):
    query = "SELECT solver_cfg, result FROM ExpResults WHERE formula_idx <= ? AND (result='unsoundness' OR result='invmodel' OR result='crash') GROUP BY solver_cfg, result"
    cursor.execute(query, (formula_idx,))
    rows = cursor.fetchall()
    distinct_groups = set()
    for row in rows:
        solver_cfg = row[0]
        result = row[1]
        group = (solver_cfg, result)
        distinct_groups.add(group)

    return  len(distinct_groups)


def query_db(db, indices):
    conn = sqlite3.connect(db)
    cursor = conn.cursor()
    lst = []
    for idx in indices:
        cursor.execute("select sum(runtime) from ExpResults where formula_idx <= {}".format(idx))
        runtime = cursor.fetchall()[0][0]
        groups = distinct_groups(cursor,idx)
        lst.append([idx, runtime, groups])
    return lst


def pretty_matrix(matrix):
    df = pd.DataFrame(matrix, columns=['Col1', 'Col2', 'Col3','Col4'])
    df['Col1'] = df['Col1'].astype(int)
    df['Col3'] = df['Col3'].astype(int)
    df['Col2'] = df['Col2'] / 2
    df['Col2'] = pd.to_datetime(df['Col2'], unit='s')

    def format_timedelta(td):
        days = td.days
        hours, remainder = divmod(td.seconds, 3600)
        minutes, _ = divmod(remainder, 60)

        formatted_time = ""
        if days > 0:
            formatted_time += f"{days} d "
        if hours > 0:
            formatted_time += f"{hours}h "
        if minutes > 0 or days == 0:
            formatted_time += f"{minutes}m"

        return formatted_time.strip()
    df['Col2'] = df['Col2'].apply(lambda x: format_timedelta(x - datetime(1970, 1, 1)))

    # Format the first and third columns to no decimal places
    df['Col1'] = df['Col1'].map('{:.0f}'.format)
    df['Col3'] = df['Col3'].map('{:.0f}'.format)
    df['Col4'] = df['Col4'].map('{:.0f}'.format)

    latex_table = df.to_latex(index=False)
    print(latex_table)


def query_db_parallel(db, indices):
    results = []
    for idx in indices:
        result = query_db(db, [idx])
        results.extend(result)
    return results

def print_results(matrix):
    pretty_matrix(matrix)

if __name__ == '__main__':
    numbers = list(range(1000, 1000001, 10000))
    db_paths = [
        "results/Arrays.db",
        "results/Core.db",
        "results/Ints.db",
        "results/Reals.db",
        "results/Bitvectors.db",
        "results/FP.db",
        "results/RealInts.db",
        "results/Strings.db"
    ]

    with multiprocessing.Pool() as pool:
        results = pool.starmap(query_db, [(db_path, numbers) for db_path in db_paths])

    m = np.sum(results, axis=0)
    num_db_paths = len(db_paths)
    m[:, 0] /= num_db_paths

    last_column = m[:, -1]
    max_value = np.max(last_column)
    percentage = (last_column / max_value) * 100
    percentage = percentage[:, np.newaxis]  # Add a new axis to match dimensions
    m = np.hstack((m, percentage))  # Append percentage column
    print_results(m)
