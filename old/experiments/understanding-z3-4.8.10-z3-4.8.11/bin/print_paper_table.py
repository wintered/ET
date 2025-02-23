import os
import pandas as pd
import sys
files = [f for f in os.listdir("csv") if ("overlap" in f) and (sys.argv[1] in f) and (sys.argv[2] in f)]
print(files)
exit(0)
df = pd.read_csv("csv/"+files[0])
df = df.drop(["0"],axis=1)
theory = files[0].split("-")[2]
df = df.rename(columns={"+": theory+"+", "-": theory+"-"})
for fn in files[1:]:
    if "RealInt" in fn or "Mixed" in fn or "Bags" in fn or "Optimization" in fn:
        continue
    df_tmp = pd.read_csv("csv/"+fn)
    theory = fn.split("-")[2]
    df_tmp = df_tmp.drop(["0","solver1","solver2"],axis=1)
    df_tmp = df_tmp.rename(columns={"+": theory+"+", "-": theory+"-"})
    df = pd.concat([df,df_tmp],axis=1)
df = df.rename(columns={"solver1":"baseline", "solver2":"solver"})
cols = [ 'solver','baseline', 'Core-', 'Core+', 'Ints-', 'Ints+', 'Reals-', 'Reals+','Bitvectors-', 'Bitvectors+', 'BitvectorArrays-', 'BitvectorArrays+','FloatingPoints-', 'FloatingPoints+', 'Strings-', 'Strings+']
df = pd.concat([df[cols[0:2]],df[cols[2:]].loc[:].div(1000).round(1)],axis=1)
minuses=['Bitvectors-']
pluses = ['Core+', 'Ints+', 'Reals+', 'Bitvectors+', 'BitvectorArrays+','FloatingPoints+','Strings+']
minuses = ['Core-', 'Ints-', 'Reals-', 'Bitvectors-', 'BitvectorArrays-','FloatingPoints-','Strings-']
df['Sum-'] = df[pluses].sum(axis=1)
df['Sum+'] = df[minuses].sum(axis=1)
df_sep = df[cols]
df_agg = df[['solver','baseline','Sum+','Sum-']]
print("\\documentclass{scrartcl}")
print("\\usepackage{booktabs}")
# print("\\usepackage{geometry}")
print("\\begin{document}")
print("""\
{
\\begin{table}
\\renewcommand{\\arraystretch}{1.2}
\\setlength{\\tabcolsep}{3.5pt}
\\tiny
\\begin{tabular}{llrrrrrrrrrrrrrr}
\\toprule
\\textbf{solver} &  \\textbf{baseline}
& + & - \\\\[0.05cm]
""")
print(df_agg.to_latex(index=False,float_format="{:.1f}".format).split("\\midrule")[1])
print("\\end{table}")
print("}")

print("""\
{
\\begin{table}
\\renewcommand{\\arraystretch}{1.2}
\\setlength{\\tabcolsep}{3.5pt}
\\tiny
\\begin{tabular}{llrrrrrrrrrrrrrr}
\\toprule
&
& \\multicolumn{2}{c}{\\textbf{Core}}
& \\multicolumn{2}{c}{\\textbf{Ints}}
& \\multicolumn{2}{c}{\\textbf{Reals}}
& \\multicolumn{2}{c}{\\textbf{BV}}
& \\multicolumn{2}{c}{\\textbf{BVA}}
& \\multicolumn{2}{c}{\\textbf{FP}}
&\\multicolumn{2}{c}{\\textbf{S}} \\\\[0.05cm]
\\cmidrule(l){3-4}
\\cmidrule(l){5-6}
\\cmidrule(l){7-8}
\\cmidrule(l){9-10}
\\cmidrule(l){11-12}
\\cmidrule(l){13-14}
\\cmidrule(l){15-16}
\\textbf{solver} &  \\textbf{baseline}
& + & -
& + & -
& + & -
& + & -
& + & -
& + & -
& + & - \\\\[0.05cm]
""")
print(df_sep.to_latex(index=False, float_format="{:.1f}".format).split("\\midrule")[1])
print("\\end{table}")
print("}")
print("\\end{document}")
