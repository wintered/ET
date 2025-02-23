#!/usr/bin/env python3

import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile
from collections import defaultdict, deque
from copy import copy
from dataclasses import dataclass
from functools import cache
from itertools import product, repeat
from math import prod
from pathlib import Path
from typing import Any, Generator, Iterable, cast

from et import cfg2rtg, utils

Structure = str
HoleDesc = str
StructureIndex = int  # Represents the n'th structure of a grammar
ProgramIndex = int  # Represents the n'th program within a !Structure!
Program = str


@dataclass
class StructureRecord:
    s_idx: StructureIndex
    structure: Structure


@dataclass
class ProgramRecord:
    s_idx: StructureIndex
    p_idx: ProgramIndex
    program: Program


def int_to_var_str(n: int) -> str:
    s = ""
    while n > 0:
        s += chr(ord("a") + (n - 1) % 26)
        n = n // 26
    return s


def generate_variables(*, amount_var: int, max_diff_var: int) -> list[list[int]]:
    if amount_var == 0:
        return []
    if amount_var == 1:
        return [[1]]
    else:
        strings = generate_variables(
            amount_var=amount_var - 1, max_diff_var=max_diff_var
        )
        new_strings = []
        for string in strings:
            for i in range(1, min(max(string) + 2, max_diff_var + 1)):
                new_string = string + [i]
                new_strings.append(new_string)
        return new_strings


class FEATProg:
    def __init__(self, grammar_str: str, ghc_path: Path = Path("ghc")) -> None:
        self.grammar_str = grammar_str.replace("EOF", "")
        self.hsgrammar = cfg2rtg.cfg_to_rtg_from_string(grammar_str)

        self._tempdir = tempfile.TemporaryDirectory()
        self._tempdir_path = Path(self._tempdir.name)

        self._grammar_path = self._tempdir_path / "grammar.hs"
        self._exe_path = self._tempdir_path / "exe"

        utils.write_file(self._grammar_path, self.hsgrammar)

        # Compile grammar
        # TODO: Handle compilation errors
        utils.run_cmd(
            f"{ghc_path} -package size-based -package base {self._grammar_path} -o {self._exe_path}"
        )

        self._buffer: deque[str] = deque()
        self._buffer_index = 0

    @staticmethod
    def _prepare_executable(grammar: Path, path: Path) -> None:
        # TODO: Duplicate code, but it's here for debugging at the moment
        # Function for debugging and testing

        if not path.exists():
            path.mkdir()

        grammar_path = path / "grammar.hs"
        exe_path = path / "exe"

        hsgrammar = cfg2rtg.cfg_to_rtg_from_path(grammar)

        utils.write_file(grammar_path, hsgrammar)

        utils.run_cmd(
            f"ghc -package size-based -package base {grammar_path} -o {exe_path}"
        )

    def __del__(self) -> None:
        self._tempdir.cleanup()

    # index function
    def __getitem__(self, index: StructureIndex) -> StructureRecord:
        return StructureRecord(
            index, utils.run_cmd(f"{self._exe_path} idx {index}").stdout
        )

    def get(self, index: StructureIndex) -> StructureRecord:
        return self[index]

    def take(self, n: int) -> list[StructureRecord]:
        stdout = utils.run_cmd(f"{self._exe_path} take {n}").stdout
        tmp = stdout.split("---DIVIDER---")
        tmp.pop()  # remove last empty string
        return [StructureRecord(i, k) for i, k in enumerate(tmp)]

    def range(self, *, start: int, stop: int) -> list[StructureRecord]:
        stdout = utils.run_cmd(f"{self._exe_path} slice {start} {stop}").stdout
        tmp = stdout.split("---DIVIDER---")
        tmp.pop()
        return [StructureRecord(i, k) for i, k in zip(range(start, stop), tmp)]

    def generator(
        self, buffer_size: int = 1000
    ) -> Generator[StructureRecord, None, None]:
        buffer: deque[StructureRecord] = deque()
        # Try to take 1000 elements at a time
        buffer.extend(self.take(buffer_size))
        idx = len(buffer)

        while True:
            if len(buffer) > 0:
                yield buffer.popleft()
            else:
                buffer.extend(self.range(start=idx, stop=idx + buffer_size))
                idx += len(buffer)
                if len(buffer) == 0:
                    break
                continue


def check_haskell_env(ghc_path: Path) -> None:
    try:
        FEATProg(utils.TRIVIAL_GRAMMAR, ghc_path=ghc_path)
    except Exception as e:
        print(f"Error: {e}")
        print(
            f"Please make sure that the Haskell environment is set up correctly and that GHC is installed."
        )
        exit(1)


@cache
def rgs_cardinality(amount_var: int, prev_mx: int, max_diff_vars: int) -> int:
    if amount_var < 1:
        return 0
    if amount_var == 1:
        return 1
    return sum(
        rgs_cardinality(amount_var - 1, max(prev_mx, i), max_diff_vars)
        for i in range(min(max_diff_vars, prev_mx + 2))
    )


def reconstruct_rgs_from_index(idx: int, max_diff_vars: int) -> list[int]:
    # find length

    l = 1
    el_accu = rgs_cardinality(l, 0, max_diff_vars)
    while idx > el_accu:
        l += 1
        el_accu += rgs_cardinality(l, 0, max_diff_vars)

    res = [0]
    idx += rgs_cardinality(l, 0, max_diff_vars)
    idx -= el_accu + 1

    while len(res) < l:
        curr_max = max(res) if res else 0
        l_rest = l - len(res)
        for i in range(curr_max + 1 + 1):
            yeah = rgs_cardinality(l_rest, max(i, curr_max), max_diff_vars)
            if yeah > idx:
                res.append(i)
                break
            idx -= yeah

    return res


class InstanceGenerator:

    def __init__(
        self,
        grammar_str: str,
        const_map: dict[HoleDesc, list[str]],
        var_decl_map: dict[HoleDesc, str],
        ghc_path: Path = Path("ghc"),
    ) -> None:

        self.feat_prog = FEATProg(grammar_str, ghc_path=ghc_path)
        self._const_map = const_map
        self._const_names = list(const_map.keys())
        self._var_decl_map = var_decl_map
        self._var_decl_names = list(var_decl_map.keys())

    @cache
    def _cardinality(self, structure: Structure, n_vars: int) -> int:
        n_holes_map = {k: structure.count(k) for k in self._var_decl_names}
        n_consts_map = {k: structure.count(k) for k in self._const_names}

        # Compute the amount of structures there will be generated for the next structure
        cardinality_1: int = prod(
            max(1, rgs_cardinality(amount_var=v, prev_mx=0, max_diff_vars=n_vars))
            for v in n_holes_map.values()
        )
        cardinality_2: int = prod(
            max(1, len(self._const_map[k]) ** v) for k, v in n_consts_map.items()
        )

        cardinality: int = max(1, cardinality_1) * max(1, cardinality_2)

        return cardinality

    def _skip_n(
        self,
        *,
        n: int,
        n_vars: int,
        feat_gen: Generator[StructureRecord, None, None],
        p_gen: Generator[ProgramRecord, None, None] | None = None,
    ) -> (
        tuple[
            Generator[StructureRecord, None, None], Generator[ProgramRecord, None, None]
        ]
        | None
    ):

        if p_gen:
            while n > 0:
                try:
                    next(p_gen)
                    n -= 1
                except StopIteration:
                    break

            if n == 0:
                return feat_gen, p_gen

        for structure_tuple in feat_gen:
            cardinality = self._cardinality(structure_tuple.structure, n_vars)

            if n - cardinality >= 0:
                n -= cardinality
                continue

            p_gen = self.generator_from_structure(structure_tuple, n_vars)

            while n > 0:
                next(p_gen)
                n -= 1

            return feat_gen, p_gen
        return None

    def _get_next(
        self,
        *,
        n_vars: int,
        feat_gen: Generator[StructureRecord, None, None],
        p_gen: Generator[ProgramRecord, None, None] | None,
    ) -> ProgramRecord | None:

        if p_gen is None:
            try:
                p_gen = self.generator_from_structure(next(feat_gen), n_vars)
            except StopIteration:
                return None

        while True:
            try:
                return next(p_gen)
            except StopIteration:
                try:
                    p_gen = self.generator_from_structure(next(feat_gen), n_vars)
                except StopIteration:
                    return None

    def take(
        self, *, n: int, n_vars: int, step_size: int = 1
    ) -> Generator[ProgramRecord, None, None]:
        n = step_size * n
        yield from self.range(start=0, stop=n, n_vars=n_vars, step_size=step_size)

    def range(
        self,
        *,
        start: int,
        stop: int,
        n_vars: int,
        step_size: int = 1,
        uniform: int = 0,
    ) -> Generator[ProgramRecord, None, None]:

        if start >= stop:
            print(
                "Warning: Start index is greater than stop index. No samples will be generated.",
                file=sys.stderr,
            )
            return None

        if (stop - start) < uniform:
            print(
                "Warning: You want to sample more samples than the range allows. Resorting to full sampling.",
                file=sys.stderr,
            )
            uniform = 0
            step_size = 1

        feat_gen = self.feat_prog.generator()

        if not (t := self._skip_n(n=start, n_vars=n_vars, feat_gen=feat_gen)):
            return None

        if uniform > 0:
            step_size = max(1, (stop - start) // (uniform + 1))

            # Do the inital skip
            if not (
                t := self._skip_n(n=step_size - 1, n_vars=n_vars, feat_gen=feat_gen)
            ):
                return None
            feat_gen, p_gen = t

        feat_gen, p_gen = t
        if uniform > 0:
            n_rest = uniform
        else:
            n_rest = max(0, stop) - max(0, start)

        n_yielded = 0

        while n_rest > n_yielded:
            try:
                yield next(p_gen)

                if step_size > 1:
                    if t := self._skip_n(
                        n=step_size - 1, n_vars=n_vars, feat_gen=feat_gen, p_gen=p_gen
                    ):
                        feat_gen, p_gen = t
                    else:
                        return None

                n_yielded += 1
            except StopIteration:
                try:
                    p_gen = self.generator_from_structure(next(feat_gen), n_vars)
                except StopIteration:
                    # If we can't generate more structures, we are done
                    return None
        return None

    def get(self, *, index: int, n_vars: int) -> ProgramRecord | None:
        feat_gen = self.feat_prog.generator()

        if t := self._skip_n(n=index, n_vars=n_vars, feat_gen=feat_gen):
            feat_gen, p_gen = t
            return self._get_next(n_vars=n_vars, feat_gen=feat_gen, p_gen=p_gen)
        return None

    def generator_from_structure(
        self, s_tuple: StructureRecord, n_vars: int
    ) -> Generator[ProgramRecord, None, None]:

        p_idx: ProgramIndex = 0
        current_structure = copy(s_tuple.structure)

        n_holes_map = {k: s_tuple.structure.count(k) for k in self._var_decl_names}
        n_consts_map = {k: s_tuple.structure.count(k) for k in self._const_names}

        # Extract all holes
        hole_regex = re.compile("|".join(self._const_names + self._var_decl_names))
        holes: list[str] = re.findall(hole_regex, current_structure)

        hole_pos_dict = defaultdict(list)

        # Create a mapping from a generator output
        # to the position of the hole in the structure
        for i, hole in enumerate(holes):
            hole_pos_dict[hole].append(i)

        # Create a generator for each hole type(!)
        order_list: list[tuple[int, HoleDesc]] = []
        gen_list: list[Iterable[Any]] = []
        for hole, count in n_holes_map.items():
            if count == 0:
                continue
            order_list.extend(zip(hole_pos_dict[hole], repeat(hole)))
            rgs = generate_variables(amount_var=count, max_diff_var=n_vars)
            rgs_str = []
            for rg in rgs:
                # Disambiguate the variables across types by adding the type as a prefix.
                # NOTE:XXX: This might cause issues later on.
                rgs_str.append([hole + "_" + int_to_var_str(n) for n in rg])
            gen_list.append(rgs_str)

        for hole, count in n_consts_map.items():
            if count == 0:
                continue
            order_list.extend(zip(hole_pos_dict[hole], repeat(hole)))
            gen_list.append(product(*repeat(self._const_map[hole], count)))

        big_gen = product(*gen_list)

        for maps in big_gen:

            # NOTE: This set might cause issues if we ever handle
            # grammars that have a scope.
            declarations = set()
            replace: list[str] = [""] * len(holes)
            tmp = []
            for l in maps:
                tmp.extend(l)

            ok = zip(tmp, order_list)

            for elem, (pos, typ) in ok:
                replace[pos] = elem
                if typ in self._var_decl_names:
                    declarations.add(self._var_decl_map[typ].format(elem) + " ")

            # FIXME: When given patterns where one is the prefix of another
            # this replacement strategy will fail.
            replaced = re.sub(hole_regex, lambda _: replace.pop(0), current_structure)

            yield ProgramRecord(
                s_idx=s_tuple.s_idx,
                p_idx=p_idx,
                program=" ".join(declarations) + " " + replaced,
            )
            p_idx += 1

    def generator(self, n_vars: int) -> Generator[ProgramRecord, None, None]:

        feat_gen = self.feat_prog.generator()

        for structure_tuple in feat_gen:
            yield from self.generator_from_structure(structure_tuple, n_vars)

    def sample_structure(
        self, p_idx: ProgramIndex, s_tuple: StructureRecord, max_diff_vars: int
    ) -> ProgramRecord | None:

        if p_idx >= self._cardinality(s_tuple.structure, max_diff_vars):
            # raise ValueError(f"ProgramIndex {p_idx} is too high for Structure {s_tuple.structure}")
            return None

        current_structure = copy(s_tuple.structure)

        n_holes_map = {k: s_tuple.structure.count(k) for k in self._var_decl_names}
        n_consts_map = {k: s_tuple.structure.count(k) for k in self._const_names}

        # Extract all holes
        hole_regex = re.compile("|".join(self._const_names + self._var_decl_names))
        holes: list[str] = re.findall(hole_regex, current_structure)

        hole_pos_dict = defaultdict(list)

        # Create a mapping from a generator output
        # to the position of the hole in the structure
        for i, hole in enumerate(holes):
            hole_pos_dict[hole].append(i)

        # Get the cardinalities
        # NOTE: This needs to be in the same order as big_gen in
        # generator_from_structure to produce the same sample sequence.

        order_list: list[tuple[int, HoleDesc]] = []
        cards: list[tuple[HoleDesc, int]] = []
        for hole, count in n_holes_map.items():
            if count == 0:
                continue
            order_list.extend(zip(hole_pos_dict[hole], repeat(hole)))
            cards.append(
                (
                    hole,
                    rgs_cardinality(
                        amount_var=count, prev_mx=0, max_diff_vars=max_diff_vars
                    ),
                )
            )

        # constants
        for hole, count in n_consts_map.items():
            if count == 0:
                continue
            amount_consts = len(self._const_map[hole])
            cards.extend([(hole, amount_consts) for _ in range(count)])
            order_list.extend(zip(hole_pos_dict[hole], repeat(hole)))

        multi = prod(x[1] for x in cards)
        idx = p_idx
        hole_args: list[Any] = []  # TODO: types
        for hole, i_card in cards:
            multi = multi // i_card

            i_idx = idx // multi
            idx -= i_idx * multi

            # index into the current hole
            if hole in self._const_map:
                hole_args.append(self._const_map[hole][i_idx])
            else:
                amount_vars = n_holes_map[hole]
                rgs_idx = i_idx + rgs_cardinality(amount_vars - 1, 0, max_diff_vars) + 1

                rg = reconstruct_rgs_from_index(rgs_idx, max_diff_vars)
                hole_args.extend([hole + "_" + int_to_var_str(n + 1) for n in rg])

        replace: list[str] = [""] * len(holes)
        declarations = set()
        for elem, (pos, typ) in zip(hole_args, order_list):
            replace[pos] = elem
            if typ in self._var_decl_names:
                declarations.add(self._var_decl_map[typ].format(elem) + " ")

        replaced = re.sub(hole_regex, lambda _: replace.pop(0), current_structure)

        return ProgramRecord(
            s_idx=s_tuple.s_idx,
            p_idx=p_idx,
            program=" ".join(declarations) + " " + replaced,
        )

    def sample_grammar(
        self, p_idx: ProgramIndex, s_idx: StructureIndex, max_diff_vars: int
    ) -> ProgramRecord | None:
        try:
            s_record = self.feat_prog.get(s_idx)
        except subprocess.CalledProcessError:
            # There's no structure at s_idx. This might happen due to
            # sampling a finite grammar.
            return None

        return self.sample_structure(p_idx, s_record, max_diff_vars)


def handle_output(
    gen: Iterable[ProgramRecord],
    output_dir: Path | None,
    output_db_path: Path | None,
) -> None:

    if output_dir:
        if output_db_path:
            conn = sqlite3.connect(output_db_path)
            cursor = conn.cursor()
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS program_records (
                    local_idx INTEGER,
                    s_idx INTEGER,
                    p_idx INTEGER,
                    program TEXT
                )
            """
            )

            # Save to db in blocks
            block_size = 10000
            block = []
            count = 0
            for case in gen:
                block.append((count, case.s_idx, case.p_idx, case.program))
                count += 1
                if len(block) >= block_size:
                    cursor.executemany(
                        """
                        INSERT INTO program_records (local_idx, s_idx, p_idx, program) 
                        VALUES (?, ?, ?, ?)
                    """,
                        block,
                    )
                    conn.commit()
                    block = []

            # Insert any remaining records
            if block:
                cursor.executemany(
                    """
                    INSERT INTO program_records (local_idx, s_idx, p_idx, program) 
                    VALUES (?, ?, ?, ?)
                """,
                    block,
                )
                conn.commit()

            conn.close()

        else:
            for i, case in enumerate(gen):
                utils.write_file(output_dir / f"{i}.smt2", case.program)
    else:
        for case in gen:
            print(case.program)


def run() -> None:

    parser = utils.get_parser()

    args = parser.parse_args()

    check_haskell_env(args.ghc)

    n_vars: int = args.n_vars

    output_dir: Path | None = None
    output_db_path: Path | None = None
    if args.output:
        path_str = str(args.output)
        if path_str.endswith(".db") or path_str.endswith(".sqlite3"):
            output_db_path = cast(Path, args.output)
            output_dir = output_db_path.parent
        else:
            output_dir = Path(args.output)
        if not output_dir.exists():
            output_dir.mkdir()

    n_step_size: int = 1
    grammar_str: str = utils.TRIVIAL_GRAMMAR
    const_map: dict[HoleDesc, list[str]] = {}
    var_decl_map: dict[HoleDesc, str] = {}

    if args.command:
        if args.command != "extract":
            grammar_str = utils.read_grammar(Path(args.grammar))

            const_map, var_decl_map = utils.read_config(Path(args.config))

        instance = InstanceGenerator(
            grammar_str=grammar_str, const_map=const_map, var_decl_map=var_decl_map
        )

        gen: Iterable[ProgramRecord] | None = None
        match args.command:
            case "take":
                n_step_size = args.step
                gen = instance.take(n=args.n, n_vars=n_vars, step_size=n_step_size)

            case "range":
                n_step_size = args.step
                n_uniform = args.uniform
                n_start = args.start
                n_stop = args.stop
                gen = instance.range(
                    start=n_start,
                    stop=n_stop,
                    n_vars=n_vars,
                    step_size=n_step_size,
                    uniform=n_uniform,
                )

            case "get":
                if res := instance.get(index=args.index, n_vars=n_vars):
                    gen = (res for _ in range(1))

            case "extract":
                theory = args.theory
                data_path = Path(__file__).parent / "data"
                config_path = data_path / f"{theory}_config.json"
                grammar_path = data_path / f"{theory}.g4"

                shutil.copy(config_path, Path.cwd())
                shutil.copy(grammar_path, Path.cwd())

            case "sample":
                s_idx = args.structure_index
                p_idx = args.program_index

                if res := instance.sample_grammar(
                    p_idx=p_idx, s_idx=s_idx, max_diff_vars=n_vars
                ):
                    gen = [res]

            case _:
                print(f"Command {args.command} not recognized")
                exit(1)
        if gen:
            handle_output(gen, output_dir=output_dir, output_db_path=output_db_path)
    else:
        parser.print_help()


if __name__ == "__main__":
    run()
