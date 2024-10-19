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
ET **exhaustively enumerates test cases** based on a context-free grammar. It 
will generate small test cases first exploiting the small-scope hypothesis which 
states that *"most bugs in software trigger on small inputs"*. Testing with small 
test cases has many unique benefits: tiny bug triggers, bounded 
guarantees, and being able to measuring software evolution.   

ET v1 supports a restricted subset of ANTLR grammars (see Customization). We 
are currently working on ET v2 to overcome many of the restrictions (planned early 2025).  
ET is built on top of <a href="https://hackage.haskell.org/package/testing-feat">testing-feat</a>, 
a Haskell testing library for enumeration of algebraic data-types.

## 🚀 Installation 
To use ET, please install the following requirements:  

```
python3
ghc
cabal
cabal install testing-feat size-based                                   
cabal install --lib testing-feat size-based
```
GNU parallel is necessary for using `bin/run_tester` to run the tool.     

To use ET, check out the repository:
```
git clone https://github.com/wintered/ET
```

## 💽 Usage  

#### 1. Generate Tester

```
bin/gen_tester grammars/Bitvectors.g4
```

This generates an executable bin/feat-Bitvectors.

#### 2. Run Tester 

```
bin/run_tester 2 1000 Bitvectors solvers.cfg 
```

This will first generate 1,000 tests in `tests/Bitvectors` using the previously 
generated tester `bin/feat-Bitvectors`. Then these tests will be forwarded 
(using 2 CPU cores) to `bin/oracle` which calls the SMT solvers from `solvers.cfg` 
and differentially tests them. 


## 📬 Feedback
For bugs/issues/questions/feature requests please file an issue. We are always happy 
to receive your feedback or help you adjust ET to the needs of your custom 
solver, help you build on ET, etc.

Contact person: [Dominik Winterer](https://wintered.github.iohttps://wintered.github.io//)

## ✍️ Publication & Findings
Our [OOPSLA '24](https://doi.org/10.1145/3689795) work uses ET to (1) validate 
the state-of-the art SMT solvers Z3 and cvc5, and (2) investigating the correctness 
and performance evolution of releases of Z3 and CVC4/cvc5 from the last 6 years.    

We devised 8 grammars one for each official SMT-LIB theory, with a fixed number 
of constants and variable realizing quantifier-free formulas for SMT solvers. 

### 🪳 Validation Campaign 
With this we conducted a validation campaign of Z3 and CVC5. We totally found 103 bugs 
in the solvers out of which 84 were confirmed by the developers, and 40 were  
already fixed. *All the bug triggers were tiny needing no further bug reduction.* 

<img width="800" alt="image" src="https://github.com/user-attachments/assets/497d154d-727e-4de1-88a6-f00042133e27">

Out of the confirmed bugs, many were performance bugs and soundness bugs.
Perhaps more importantly anything are the assurance that we gained. 
**Z3 and cvc5 no longer have simple bugs**.

### Evolution 
Another question we can now attempt is whether SMT solvers have become better, 
*Have we tested SMT solvers enough?* How did they evolve wrt. correctness  
and performance? To approach these questions, we stacked up all releases of 
Z3 and CVC4/cvc5 from the last 6 years (61 releases). 

### Correctness (Nov 2016 - Mar 2024)
Considering correctness, we ran ET with grammars of each theory (represented by 
the different colors), tracking the number of bugs that each 

<img width="1200" alt="image" src="https://github.com/user-attachments/assets/e9f05473-cd9d-4630-80dc-fd96a888cd4f">
<img width="1200" alt="image" src="https://github.com/user-attachments/assets/034f5271-6782-49ec-9804-bcb2ab989459">

For Z3 (top), we observe that initially there ET triggers many bugs up and then 
drops down. For CVC4/cvc5 (bottom), we see a similar drops in bugs. Strikingly, releases 
of both solvers do not exhibit soundness bugs after z3-4.8.9 and cvc5-0.0.8, respectively.    
In sum, **we observe that the correctness of Z3 and CVC4/cvc5 increased significantly**.   

### Performance (Nov 2016 - Mar 2024) 

## Customizing ET 
ET is a generic framework applicable beyond SMT solvers by using different           
grammars and oracles. Currently ET supports a restricted subset of ANTLR grammar  
format (from the ANTLR parser generator). For targets other than SMT solvers,   
the oracle needs domain-specific adjustments bin/oracle. 

### Running ET on custom grammars
ET v1 currently supports only a basic fragment of ANTLR grammars. To engineer a grammar for which 
ET can generate test cases, you need to avoid (1) syntactic sugar (+,\*,?), (2) other advanced 
ANTLR features, and (3) fix the number of constants and variables. The script 
`etc/validate_grammar` can be helpful while grammar engineering.    

### Structure of the project   
ET is realized by a collection of bash and python scripts. The most important    
files are described below:   

```
.
├── bin
│   ├── gen_tester          - given <grammar>, generate exhaustive tester bin/feat-<grammar>    
│   ├── feat-<grammar>      - given <num_tests> <folder> exhaustively generate tests    
│   ├── oracle              - script for differential testing SMT solvers   
│   └── run_tester          - generate and run tests
├── etc
│   ├── cfg2rtg             - Transform CFG to algebraic datatypes 
│   ├── antlr.jar           - ANTLR runtime
│   └── validate_grammar    - checks validity of grammars (useful for grammar engineering)  
├── grammars                - SMT grammars realizing quantifier-free formulas   
│   ├── Arrays.g4
│   ├── Bitvectors.g4
│   ├── Core.g4
│   ├── FP.g4
│   ├── Ints.g4
│   ├── RealInts.g4
│   ├── Reals.g4
│   └── Strings.g4
└── solvers.cfg         - solver configurations considered by oracle 
```

## Citing ET
```
@article{winterer-su-oopsla2024,
    author = {Winterer, Dominik and Su, Zhendong},
    title = {Validating SMT Solvers for Correctness and Performance via Grammar-Based Enumeration},
    year = {2024},
    number = {OOPSLA2},
    url = {https://doi.org/10.1145/3689795},
    doi = {10.1145/3689795},
    journal = {Proc. ACM Program. Lang.},
    articleno = {355},
    numpages = {24},
}
```
