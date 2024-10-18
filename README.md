<p align="center"><a><img width="200" alt="portfolio_view" align="center" src="https://wintered.github.io/img/ET/Logo/PNG/logo.png"></a></p>


ET: Software Testing with Assurances
=======================================

An enumerative testing framework. Given an context-free grammar (in ANTRL format) and a number of desired tests, ET enumerates **the smallest inputs** from that 
grammar. ET can be used to stress-test software exploiting the small-scope hypothesis [Jackson '04] 

ET is built on top of testing-feat, a Haskell testing library for enumeration of algebraic datatypes.

## Installation 

ET has the following requirements:  

```
python3
ghc
cabal
cabal install testing-feat 
cabal install size-based
```
GNU parallel is necessary for using `bin/run_tester` to run the tool.     

To use ET, check out the repository:
```
git clone https://github.com/wintered/ET
```

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

This will first generate 10,0000 tests in `tests/Bitvectors` (i.e., call bin/feat-Bitvectors).
Then these tests will be forwarded (using 10 cores) to `bin/oracle` which calls 
the SMT solvers from `solvers.cfg` and differentially tests them.  


### Validating grammars with ANTLR  
```
etc/validate_grammar grammars/Bitvectors.g4
```

