<p align="center"><a><img width="1600" alt="portfolio_view" align="center" src="https://wintered.github.io/img/ET/Logo/PNG/logo.png"></a></p>


ET
===

## Requirements 

```
python3
ghc 
cabal
cabal install testing-feat 
cabal install size-based
```
GNU parallel is necessary for using bin/run_tester to run the tool.     

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

## Usage

### 1. Generate tester

```
bin/gen_tester grammars/Bitvectors.g4
```

This generates the executable bin/feat-Bitvectors.

### 2. Run tester 

```
bin/run_tester 10 100000 Bitvectors solvers.cfg 
```

This will first generate 100000 tests in tests/Bitvectors (i.e. call bin/feat-Bitvectors).
Then these tests will be forwarded (using 10 cores) to bin/oracle which calls 
the SMT solvers from solvers.cfg and differentially tests them.  


### Validating grammars with ANTLR  
```
etc/validate_grammar grammars/Bitvectors.g4
```

