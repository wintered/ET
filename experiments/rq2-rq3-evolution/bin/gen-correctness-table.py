import pandas as pd
import copy 
df=pd.read_csv("csv/correctness_results.csv.avg")
solvers = open("../solvers.cfg").readlines()[3:]
solvers = [sol.split(" ")[0] for sol in solvers]

for sol in solvers:
    print(sol + " & ",end="")
    print(str(df[(df['type'] == 'unsoundness') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print(str(df[(df['type'] == 'invalid model') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print(str(df[(df['type'] == 'crash') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print("\\\\")
