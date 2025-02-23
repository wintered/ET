ET: Exhaustive Testing
=====================

`et` exhaustively generates test cases based on a provided context-free grammar. It will generate small test cases first thereby leveraging the Small Scope Hypothesis.
The Small Scope Hypothesis argues that a high proportion of the bugs in a program can be found by thoroughly testing a small 'scope' of the whole input space.
Compared to a naive enumeration approach, `et` avoids duplicates based on variables, drastically reducing the program space.

`et` internally leverages [feat](https://github.com/JonasDuregard/testing-feat)([paper](https://dl.acm.org/doi/10.1145/2430532.2364515)), to achieve parts of the enumeration.

## Requirements 

```
python3
pip
ghc 
cabal
cabal install --lib testing-feat 
cabal install --lib size-based
```

## Installation

After having installed the above requirements, you can install `et` via pip.
```
pip install $FIGURE_OUT_NON_CLASHING_NAME
```

Alternatively, you can clone the repository and install `et` via . 
```
python3 -m venv ./venv
source ./venv/bin/activate
pip install poetry

poetry install
```

If poetry seems to get stuck updating packages/package registries, it might be caused by poetry [waiting for the keyring](https://stackoverflow.com/questions/58708936/pythonpoetry-installation-is-getting-stuck#60804443).
A temporary fix for this issue can be achieved by running `poetry install` again with the `PYTHON_KEYRING_BACKEND` set to the null keyring.
```
PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring poetry install
```

## Usage
**TL;DR**
```
export N=100
et extract Core
# Print first 100 elements based on the Core grammar
et take $N ./Core.g4 ./Core_config.json
```

`et` requires a grammar and a config file for the grammar. You can get predefined grammars and config pairs by `extract`-ing them from `et` in. One of these pairs is `Core` which we extract as follows:
```
et extract Core
```
This will copy `Core.g4` and `Core_config.json` into you current directory. 
You can then generate the first `N` elements of this grammar. In this example, `N=100`.
```
et take 100 ./Core.g4 ./Core_config.json
```

## More usage examples
In the following examples, `$G` stands for the path to a G4 grammar and `$C` stands for the path of the associated `config.json`.

| Command | Explanation |
| --- | --- |
| `et get $IDX $G $C` | Get the element at position `$IDX` |
| `et take $N $G $C` | Get the first `$N` elements |
| `et range $START $END $G $C` | Get the elements starting at `$START` to `$STOP` (exclusive) |
| `et range --step $K $START $END $G $C` | Make steps of size `$K` between the elements within the range `$START` to `$STOP`. Also works for `take`. |
| `et range --uniform $N $START $END $G $C` | Take `$N` evenly spaced elements within the defined range |
| `et --output $DIR take 100 $G $C` | Save the first 100 elements into `$DIR` instead of printing to `stdout` |
| `et --n-vars $NV take 100 $G $C` | Get the first 100 elements that may include up to `$NV` **different** variables |


## References
- [Feat: functional enumeration of algebraic types](https://dl.acm.org/doi/10.1145/2430532.2364515)
- [testing-feat](https://github.com/JonasDuregard/testing-feat)
