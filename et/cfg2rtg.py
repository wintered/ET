#! /usr/bin/env python3
#
# Transforms a context free grammar (CFG) into a regular tree grammar (RTG)
# suitable for testing-FEAT,  i.e. practically speaking
#    ANTLR grammar file -> algebraic datatype + feat additions
#
# Assumption:
#   w.o.l.g. CFG's productions are either P -> v1...vn with vi nonterminal
#                                  or     P -> e1...em with e1 terminals

from pathlib import Path


def cfg_to_rtg_from_path(grammar_path: Path) -> str:
    if not grammar_path.exists():
        print(f"Error: {grammar_path} does not exist.")
        exit(1)

    prods_str = open(grammar_path).read().replace("EOF", "")

    return cfg_to_rtg_from_string(prods_str)


def cfg_to_rtg_from_string(prods_str: str) -> str:
    prods = prods_str.split(";")[0:-1]
    prods = prods[1:]

    program = """
import Data.List
import System.IO
import System.Exit
import System.Environment

import Test.Feat.Enumerate
import Control.Enumerable
import Test.Feat.Access
import Test.Feat
    """

    for i in range(0, len(prods)):
        prod = prods[i].strip("\n")
        lhs = prod.split(":")[0].strip()
        rhs_str = prod.split(":")[1].strip()
        rhs = [r.strip() for r in rhs_str.split("|")]
        s = ""
        for i, r in enumerate(rhs):
            con = "C" + str(i) + "_" + lhs.capitalize()
            s += con.capitalize() + " "
            if not r.startswith("'"):  # arity >= 1
                s += " ".join([c.capitalize() for c in r.split(" ")])
            s += "| "
        program += "\ndata {} = {}\n".format(lhs.capitalize(), s[:-2])
        program += "instance Show {} where\n".format(lhs.capitalize())
        for i, r in enumerate(rhs):
            con = "C" + str(i) + "_" + lhs.capitalize()
            if r.startswith("'"):  # arity = 0
                program += "  show {} = {}\n".format(
                    con.capitalize() + " ", r.replace('"', '\\"').replace("'", '"')
                )
            else:  # arity >= 1
                arg_str = " ".join(["a" + str(j) for j, _ in enumerate(r.split(" "))])
                show_str = "show " + ' ++ " " ++ show '.join(
                    ["a" + str(j) for j, _ in enumerate(r.split(" "))]
                )
                program += "  show ({}{}) = {}\n".format(
                    con.capitalize() + " ", arg_str, show_str
                )
        program += "instance Enumerable {} where\n".format(lhs.capitalize())
        program += "  enumerate = share $ aconcat ["
        for i, r in enumerate(rhs):
            if i != 0:
                program += ","
            con = "C" + str(i) + "_" + lhs.capitalize()
            if r.startswith("'"):  # arity = 0
                program += "c{} {}".format(0, con.capitalize())
            else:
                if lhs in r.split(" "):  # recursive production
                    program += "pay(c{} {})".format(len(r.split(" ")), con.capitalize())
                # Dominik: this only works with SMT-LIB grammars
                # Intuition: pay if zero cost cycle of rules
                elif "ParOpen" in r.split(" "):
                    program += "pay(c{} {})".format(len(r.split(" ")), con.capitalize())
                else:
                    program += "c{} {}".format(len(r.split(" ")), con.capitalize())
        program += "]\n\n"

    program += """
putStrLnWithDivider x = putStr x >> putStr "---DIVIDER---"

failure = do
    progName <- getProgName
    putStrLn ("Usage: " ++ progName ++ " (idx|take <integer>) | slice <integer> <integer>")
    exitWith (ExitFailure 1)

main = do
    args <- getArgs

    let lst = concat $ map snd (values :: [(Integer, [Start])])
    case args of
        [aString, aInterger] -> do
            let n = read aInterger :: Int

            if aString == "idx" then
                putStrLn $ show $ lst !! n
            else if aString == "take" then
                sequence_ $ map putStrLnWithDivider $ take n $ map show lst 
            else do
                failure
        [aString, aInterger, bInteger] -> do
            let n = read aInterger :: Int
            let m = read bInteger :: Int

            if aString == "slice" then
                sequence_ $ map putStrLnWithDivider $ take (m - n + 1) $ drop n $ map show lst
            else if n > m then
                failure
            else do
                failure

        _ -> do
            failure
    """

    return program
