import argparse
import json
import os
import shlex
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any

TRIVIAL_GRAMMAR = """
grammar trivial;

var
    : 'VAR'
    ;

var64
    : 'TAR64'
    ;

constant
    : 'CONST'
    ;

constant64
    : 'TONST64'
    ;

lparen
    : '('
    ;

rparen
    : ')'
    ;

plus
    : '+'
    ;

op_add_1
    : var
    | var64
    | constant
    | constant64
    | lparen op_add_2 plus op_add_2 rparen
    ;

op_add_2
    : var
    | var64
    | constant
    | constant64
    ;

start
    : op_add_1
    ;
"""

CONST_MAP = {
    "CONST": ["1", "2", "3"],
    "TONST64": ["4", "5", "6"],
}

VAR_DECL_MAP = {
    "VAR": "INT {};",
    "TAR64": "INT64 {};",
}


@dataclass(frozen=True, kw_only=True)
class CommandOutput:
    stdout: str
    stderr: str


def run_cmd(
    cmd: str | list[str],
    working_dir: Path | None = None,
    additional_env: dict[str, str] = {},
    **kwargs: Any,  # https://github.com/python/mypy/issues/8772
) -> CommandOutput:
    if working_dir is None:
        working_dir = Path(os.getcwd())
    env = os.environ.copy()
    env.update(additional_env)

    if isinstance(cmd, list):
        cmd = " ".join(cmd)
    output = subprocess.run(
        shlex.split(cmd.replace('"', '\\"')),
        cwd=str(working_dir),
        check=True,
        env=env,
        capture_output=True,
        **kwargs,
    )

    return CommandOutput(
        stdout=output.stdout.decode("utf-8").strip(),
        stderr=output.stderr.decode("utf-8").strip(),
    )


def read_file(file_path: Path) -> str:
    if not file_path.exists():
        raise FileNotFoundError(f"{file_path} does not exist.")
    with open(file_path, "r") as f:
        return f.read()


def write_file(file_path: Path, content: str) -> None:
    if not file_path.parent.exists():
        file_path.parent.mkdir(parents=True)
    with open(file_path, "w") as f:
        f.write(content)


def read_config(config_path: Path) -> tuple[dict[str, list[str]], dict[str, str]]:
    raw = json.loads(read_file(config_path))
    const_map, variable_decl_map = raw["constants"], raw["variables"]

    all_holes: list[str] = list(const_map.keys()) + list(variable_decl_map.keys())

    for a in all_holes:
        for b in all_holes:
            if a.startswith(b) and a != b:
                raise ValueError(f"{a} is a prefix of {b}")

    return const_map, variable_decl_map


def read_grammar(grammar_path: Path) -> str:
    return read_file(grammar_path).replace("EOF", "")


def get_parser() -> argparse.ArgumentParser:
    # TODO: There's a lot of repetition here because I wanted the grammar and config path
    # to be last in the CLI, but with the subparsers, this seems to require specifying
    # the args in everyone of them.

    parser = argparse.ArgumentParser(description="Generate RTG from CFG")

    subparsers = parser.add_subparsers(dest="command")

    parser.add_argument(
        "--output",
        type=Path,
        help="Save to directory or a sqlite db if the path ends in .db or .sqlite3",
    )

    parser.add_argument(
        "--n-vars",
        type=int,
        help="Maximum amount of different variables to generate",
        default=2,
    )

    parser.add_argument("--ghc", type=Path, help="Path to GHC", default=Path("ghc"))

    take_parser = subparsers.add_parser("take", help="Take n elements from generator")
    take_parser.add_argument(
        "n", type=int, help="Amount of elements to take from generator"
    )
    take_parser.add_argument("--step", type=int, help="Step size", default=1)
    take_parser.add_argument("grammar", type=str, help="Path to grammar file")
    take_parser.add_argument(
        "config",
        type=str,
        help="The configuration file that specifies the constants and variables",
    )

    range_parser = subparsers.add_parser("range", help="Take a range of elements")
    range_parser.add_argument("start", type=int, help="Start index")
    range_parser.add_argument("stop", type=int, help="Stop index")
    range_parser.add_argument("--step", type=int, help="Step size", default=1)
    range_parser.add_argument(
        "--uniform", type=int, default=0, help="Uniformly sample n samples from range"
    )
    range_parser.add_argument("grammar", type=str, help="Path to grammar file")
    range_parser.add_argument(
        "config",
        type=str,
        help="The configuration file that specifies the constants and variables",
    )

    get_parser = subparsers.add_parser("get", help="Get element at index")
    get_parser.add_argument("index", type=int, help="Index to get")
    get_parser.add_argument("grammar", type=str, help="Path to grammar file")
    get_parser.add_argument(
        "config",
        type=str,
        help="The configuration file that specifies the constants and variables",
    )

    extract_parser = subparsers.add_parser(
        "extract", help="Copy pre-written files into current directory"
    )
    data_path = Path(__file__).parent / "data"
    choices = [f.stem.split("_")[0] for f in data_path.glob("*.json")]
    extract_parser.add_argument("theory", choices=choices, help="Theory to extract")

    sample_parser = subparsers.add_parser("sample")
    sample_parser.add_argument("structure_index", type=int)
    sample_parser.add_argument("program_index", type=int)
    sample_parser.add_argument("grammar", type=str, help="Path to grammar file")
    sample_parser.add_argument(
        "config",
        type=str,
        help="The configuration file that specifies the constants and variables",
    )

    return parser
