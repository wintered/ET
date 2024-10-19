import pandas as pd 
from encrypt import privacy_key  
# encrypt.py (needs to be created)
# Format:
# privacy_key=<your github privacy key>
#
from github import Github
import numpy as np

repo-name="" # put repo name here
g = Github(privacy_key)
repo = g.get_repo()
issues = repo.get_issues(state='open')

def has_labels(issue,labels):
    issue_labels = [l.name for l in issue.labels]
    if type(labels) == str:
        return labels in issue_labels
    for l in labels:
        if not l in issue_labels: return False
    return True

def bug_status_table():
    table=[]
    for solver in ["Z3","cvc5"]:
        reported, confirmed, fixed, duplicate, wontfix = 0, 0, 0, 0, 0
        for iss in issues: 
            if has_labels(iss,[solver]): reported += 1
            if has_labels(iss,["Confirmed",solver]) or\
               has_labels(iss,["Fixed",solver]): confirmed += 1
            if has_labels(iss,["Fixed",solver]): fixed += 1 
            if has_labels(iss,["Duplicate",solver]): duplicate += 1
            if has_labels(iss,["Won't fix",solver]): wontfix+= 1
        col = [reported, confirmed, fixed, duplicate, wontfix]
        table.append(col)
    sum_row = np.array(table[0]) + np.array(table[1])
    table.append(sum_row)
    df = pd.DataFrame(data=table).transpose()
    return df.to_latex()

def bug_type_table():
    table=[]
    for solver in ["Z3","cvc5"]:
        crash, soundness,inv_model,others, performance = 0,0,0,0,0
        for iss in issues:
            if not (has_labels(iss,["Confirmed",solver]) or\
               has_labels(iss,["Fixed",solver])):
                continue
            if has_labels(iss, [solver,"Crash"]):
                crash += 1
            elif has_labels(iss,[solver,"Soundness"]):
                soundness += 1
            elif has_labels(iss,[solver,"Invalid model"]):
                inv_model += 1
            elif has_labels(iss,[solver,"Performance"]):
                performance += 1
            elif has_labels(iss,[solver]):
                others += 1
        col = [crash, soundness, inv_model, performance, others]
        table.append(col)
    sum_row = np.array(table[0]) + np.array(table[1])
    table.append(sum_row)
    df = pd.DataFrame(data=table).transpose()
    return df.to_latex()

def bug_opts():
    table=[]
    for solver in ["Z3","cvc5"]:
        default, one,two,threeormore= 0,0,0,0  
        for iss in issues: 
            if not (has_labels(iss,["Confirmed"]) or has_labels(iss,["Fixed"])): continue
            if has_labels(iss,[solver,"default"]): default +=1
            if has_labels(iss,[solver,"1"]): one+=1
            if has_labels(iss,[solver,"2"]): two+=1
            if has_labels(iss,[solver,"3+"]): threeormore+=1
        col = [default, one, two,threeormore]
        table.append(col)
    sum_row = np.array(table[0]) + np.array(table[1])
    table.append(sum_row)
    df = pd.DataFrame(data=table).transpose()
    return df.to_latex()

def affected_logics():
    table=[]
    for theory in ["Core","Arrays","Bitvectors","Core","FP","Ints","RealInts","Reals","Strings"]:
        col = []
        col.append(theory)
        for solver in ["Z3","cvc5","Total"]:
            count = 0
            for iss in issues:
                # if not has_labels(iss,["Performance"]): continue
                # if not (has_labels(iss,["Confirmed"]) or has_labels(iss,["Fixed"])): continue
                if has_labels(iss,[solver]) and has_labels(iss,[theory]):
                   count += 1
                if solver == "Total" and has_labels(iss,[theory]): 
                    count +=1
            col.append(count)
        table.append(col)
    # print(table)
    # sum_row = np.array(table[0]) + np.array(table[1])
    # table.append(sum_row)
    df = pd.DataFrame(data=table) #.transpose()
    return df.to_latex(index=None)
print(bug_status_table())
print()
print(bug_type_table())
print()
print(bug_opts())
