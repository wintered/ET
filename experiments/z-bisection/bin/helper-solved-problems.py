import sys
fn=sys.argv[1]
lines = open(fn).read().split("\n")[:-1]
theory = fn.split("-")[1].split(".")[0]
for line in lines:
    familiy = "Z3" if "z3" in line else "CVC4/5"
    sol = line.split(",")[0].split(" ")[0]
    print(sol+","+",".join(line.split(",")[1:]) +","+theory + "," + familiy)
