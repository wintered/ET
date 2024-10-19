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
guarantees, and measuring software evolution. 

ET is built on top of <a href="https://hackage.haskell.org/package/testing-feat">testing-feat</a>, 
a Haskell testing library for enumeration of algebraic datatypes.

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

This generates the executable bin/feat-Bitvectors.

#### 2. Run Tester 

```
bin/run_tester 2 1000 Bitvectors solvers.cfg 
```

This will first generate 1,000 tests in `tests/Bitvectors` using the previously 
generated tester in `bin/feat-Bitvectors`. Then these tests will be forwarded 
(using 2 CPU cores) to `bin/oracle` which calls the SMT solvers from `solvers.cfg` 
and differentially tests them.  


## 📬 Feedback
For bugs/issues/questions/feature requests please file an issue. We are always happy 
to receive your feedback or help you adjust ET to the needs of your custom 
solver, help you build on ET, etc.

Contact person: [Dominik Winterer](https://wintered.github.iohttps://wintered.github.io//)

## ✍️ Publication & Findings

### 🪳Bug Findings
<img width="800" alt="image" src="https://github.com/user-attachments/assets/497d154d-727e-4de1-88a6-f00042133e27">

### Correctness (Nov 2016 - Mar 2024)
<img width="1400" alt="image" src="https://github.com/user-attachments/assets/e9f05473-cd9d-4630-80dc-fd96a888cd4f">
<img width="1400" alt="image" src="https://github.com/user-attachments/assets/034f5271-6782-49ec-9804-bcb2ab989459">



## ➕ Additional Resources
-  
