<p align="center">
    <a><img width="200" alt="portfolio_view" align="center" src="https://wintered.github.io/img/ET/Logo/PNG/logo.png"></a>
</p>
<br />
<div align="center">
    <a href="https://github.com/wintered/ET/actions/workflows/ci.yml">
        <img src="https://github.com/wintered/ET/actions/workflows/ci.yml/badge.svg" alt="Python & Haskell CI" />
    </a>
    <a href="https://opensource.org/licenses/MIT" alt="License">
        <img src="https://img.shields.io/badge/License-MIT-yellow.svg" />
    </a>
</div>
<br>

ET: Enumerative Testing of SMT Solvers
==============================================
ET **exhaustively enumerate test cases** based on a context-free grammar.  It will generate small test cases first exploiting the
the small-scope hypothesis which states that *"most bugs in software trigger on small inputs"*. Testing with small test cases has many unique benefits
in particular small bug triggers, bounded guarantees, an measuring software evolution. 

ET is built on top of <a href="https://hackage.haskell.org/package/testing-feat">testing-feat</a>, a Haskell testing library for enumeration of algebraic datatypes.

## Installation 

To use ET, please install the following requirements:  

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

## Usage

### Generate tester

```
bin/gen_tester grammars/Bitvectors.g4
```

This generates the executable bin/feat-Bitvectors.

### Run tester 

```
bin/run_tester 2 1000 Bitvectors solvers.cfg 
```

This will first generate 1,000 tests in `tests/Bitvectors` using the previously generated tester in `bin/feat-Bitvectors`.
Then these tests will be forwarded (using 2 CPU cores) to `bin/oracle` which calls 
the SMT solvers from `solvers.cfg` and differentially tests them.  

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


