import pandas as pd
import copy 
df=pd.read_csv("correctness_results.csv")
solvers=[
"z3-4.12.1",
"z3-4.12.0",
"z3-4.11.2",
"z3-4.11.0",
"z3-4.10.2",
"z3-4.10.1",
"z3-4.10.0",
"z3-4.9.1",
"z3-4.9.0",
"z3-4.8.16",
"z3-4.8.15",
"z3-4.8.14",
"z3-4.8.13",
"z3-4.8.12",
"z3-4.8.11",
"z3-4.8.10",
"z3-4.8.9",
"z3-4.8.8",
"z3-4.8.7",
"z3-4.8.6",
"z3-4.8.5",
"z3-4.8.4",
"z3-4.8.3",
"z3-4.8.1",
"z3-4.7.1",
"z3-4.6.0",
"z3-4.5.0",
"cvc5-1.0.5",
"cvc5-1.0.4",
"cvc5-1.0.3",
"cvc5-1.0.2",
"cvc5-1.0.1",
"cvc5-1.0.0",
"cvc5-0.0.12",
"cvc5-0.0.11",
"cvc5-0.0.10",
"cvc5-0.0.8",
"cvc5-0.0.7",
"cvc5-0.0.6",
"cvc5-0.0.5",
"cvc5-0.0.4",
"cvc5-0.0.3",
"cvc5-0.0.2",
"cvc4-1.8",
"cvc4-1.7",
"cvc4-1.6",
"cvc4-1.5"
]
for sol in solvers:
    print(sol + " & ",end="")
    print(str(df[(df['type'] == 'unsoundness') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print(str(df[(df['type'] == 'invalid model') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print(str(df[(df['type'] == 'crash') & (df['solver'] == sol)]['num_triggers'].sum()) + " & ", end="")
    print("\\\\")
