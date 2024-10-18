## Structure 
```
bin/
├── gen_tester          - given <grammar>, generate exhaustive tester bin/feat-<grammar>    
├── feat-<grammar>      - given <num_tests> <folder> generate tests    
├── oracle              - script for differential testing SMT solvers   
└── run_tester          - generate and run tests
grammars/               - smtlib grammars
etc/                    - helper scripts, antlr  (for validating grammars)
solvers.cfg             - solver configurations
```
