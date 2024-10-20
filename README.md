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
guarantees, the ability to measure the evolution of a software.   

 ET is built on top of <a href="https://hackage.haskell.org/package/testing-feat">testing-feat</a>, a Haskell testing library for enumeration of algebraic data types. ET v1 supports a restricted subset of ANTLR grammars (see Customization). We are currently working on ET v2 to overcome many of these restrictions (planned for early 2025).

## 🚀 Installation 
To use ET, please install the following requirements:  

```
python3
parallel
ghc, cabal
cabal install testing-feat size-based                                   
cabal install --lib testing-feat size-based
```
To use ET, check out the repository:
```
git clone https://github.com/wintered/ET
```

## 💽 Usage  

#### 1. Generate Tester

```
bin/gen_tester grammars/Bitvectors.g4
```

This generates an executable `bin/feat-Bitvectors`.

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
We conducted a validation campaign of Z3 and CVC5. We totally found 103 bugs 
in the solvers out of which 84 were confirmed by the developers, and 40 were already fixed. *All bug triggers were tiny needing no further bug reduction.* 

<img width="800" alt="image" src="https://github.com/user-attachments/assets/497d154d-727e-4de1-88a6-f00042133e27">
<br>
<br>

Out of the confirmed bugs, many were performance bugs and soundness bugs.
Perhaps more importantly anything are the assurances that we gained. 
**We can be more confident that Z3 and cvc5 no longer have simple bugs**.

### Evolution (Nov 2016 - Mar 2024)
The small scope hyothesis states  ' i.e. *almost all bugs in software have small [Jackson

*Have we tested SMT solvers enough?* How did SMT solver's correctness  
and performance evolve? To approach these questions, we stacked up all releases of 
Z3 and CVC4/cvc5 from the last 6 years (61 releases). We then ran ET with grammars 
of each theory tracking the number of bugs found and runtime.  

### Correctness 
For correctness, we make the following observations:  Z3 initially 
has many bugs in almost all theories (represented by the different colors).  
However, after z3-4.8.8, there are much less, with some releases not triggering    
any bugs any more. 

<img width="1200" alt="image" src="https://github.com/user-attachments/assets/e9f05473-cd9d-4630-80dc-fd96a888cd4f">

For CVC4/cvc5, we see a similar trend: bugs in many theories in cvc4-1.5-7,     
and progressively less bugs in later versions 

<img width="1200" alt="image" src="https://github.com/user-attachments/assets/034f5271-6782-49ec-9804-bcb2ab989459">

Our experiment further showed that releases of both solvers do not exhibit soundness bugs after z3-4.8.9 and cvc5-0.0.8, respectively.    
Hence, we conclude that  **the correctness of Z3 and CVC4/cvc5 increased significantly**.   

### Performance

We decreased performance in newer releases of Z3 on small timeouts (since z3-4.8.11) 
and regressions in early cvc5 releases on larger timeouts. For performance, we 
tracked the number of solved formulas from the lowest timeout of 0.015625s to 
the highest timeout of 8s. Lower timeouts help understand small aggregating effects 
while higher timeouts help understand performance regressions. For the lowest 
timeout (0.015625s), CVC4/cvc5's performance is roughly constant, but the 
performance of Z3 versions from 4.8.11 onwards worsened with a significant 
decrease from z3-4.8.10 to z3-4.8.11 (see top-left). For the 
highest timeout of 8s, Z3 is roughly constant while cvc5's performance declines 
and then recovers. <TODO: figure>

## 🔩 Customization 
ET is a generic framework applicable beyond SMT solvers by using different grammars and oracles. Currently ET supports a restricted subset of context-free [ANTLR grammars](https://www.antlr.org/). For targets other than SMT solvers, the oracle needs domain-specific adjustments `bin/oracle`. 

### Running ET on custom grammars
ET v1 currently supports only a basic fragment of ANTLR grammars. To engineer a grammar for which 
ET can generate test cases, you need to avoid (1) syntactic sugar (e.g, `+,\*,?`), (2) other advanced 
ANTLR features, and (3) fix the number of constants and variables. The script `etc/validate_grammar` can be helpful while grammar engineering.    

### Structure of the project   
ET is realized by a collection of bash and python scripts. The most important files are described below:   

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
├── experiments             - scripts for experiments (OOPSLA '24)    
└── solvers.cfg             - solver configurations considered by oracle 
```

## 📖 Citing ET
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
