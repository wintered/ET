import subprocess
from datetime import timedelta
from functools import cache

import hypothesis.strategies as st
from hypothesis import assume, given, settings

from et.main import FEATProg, InstanceGenerator, ProgramRecord
from et.utils import CONST_MAP, TRIVIAL_GRAMMAR, VAR_DECL_MAP

INSTANCE = InstanceGenerator(
    grammar_str=TRIVIAL_GRAMMAR, const_map=CONST_MAP, var_decl_map=VAR_DECL_MAP
)

FEAT_PROG = FEATProg(grammar_str=TRIVIAL_GRAMMAR)


@cache
def instance_map(n_vars: int) -> tuple[ProgramRecord, ...]:
    return tuple(INSTANCE.generator(n_vars))


def test_trivial_grammar_generation() -> None:

    structures = list(FEAT_PROG.generator())

    assert len(structures) == 20


def test_instance_generator_take_eq_generator() -> None:

    n_vars = 5
    n_take = 20

    instance_gen = iter(instance_map(n_vars))

    res_gen = tuple(next(instance_gen) for _ in range(n_take))

    res_take = tuple(INSTANCE.take(n=n_take, n_vars=n_vars))

    assert res_gen == res_take


def test_instance_take_eq_sample() -> None:

    n_amount = 100
    n_vars = 5

    res_take = list(INSTANCE.take(n=n_amount, n_vars=n_vars))

    res_sample = []
    s_idx = 0
    while n_amount > 0:
        try:
            s = INSTANCE.feat_prog.get(s_idx)
        except subprocess.CalledProcessError:
            break

        card = INSTANCE._cardinality(s.structure, n_vars)

        for i in range(min(card, n_amount)):
            res_sample.append(INSTANCE.sample_structure(i, s, max_diff_vars=n_vars))

        n_amount -= card
        s_idx += 1

    assert res_sample == res_take


@settings(deadline=timedelta(seconds=2))
@given(n_skip=st.integers(min_value=-1, max_value=50))
def test_instance_generator_skip_n(n_skip: int) -> None:
    n_vars = 5

    instance_gen = iter(instance_map(n_vars))

    for _ in range(n_skip):
        next(instance_gen)

    res_gen = next(instance_gen)

    feat_gen = FEAT_PROG.generator()

    if (t := INSTANCE._skip_n(n=n_skip, n_vars=n_vars, feat_gen=feat_gen)) is None:
        assert False

    feat_gen, p_gen = t

    res_skip = INSTANCE._get_next(n_vars=n_vars, feat_gen=feat_gen, p_gen=p_gen)

    assert res_gen == res_skip


@settings(deadline=timedelta(seconds=2))
@given(step_size=st.integers(min_value=1, max_value=100))
def test_instance_generator_take_step_size(step_size: int) -> None:
    n_vars = 5

    instance_gen = iter(instance_map(n_vars))

    res_gen = [v for i, v in enumerate(instance_gen) if i % step_size == 0]

    res_range = list(INSTANCE.take(n=len(res_gen), n_vars=n_vars, step_size=step_size))

    assert len(res_gen) == len(res_range)

    for g, s in zip(res_gen, res_range):
        assert g == s


@settings(deadline=timedelta(seconds=1))
@given(
    n_start=st.integers(min_value=-10, max_value=10),
    n_stop=st.integers(min_value=-10, max_value=10),
)
def test_instance_generator_range(n_start: int, n_stop: int) -> None:

    assume(n_start < n_stop)

    n_vars = 5

    instance_gen = iter(instance_map(n_vars))

    for _ in range(n_start):
        next(instance_gen)

    res_gen = [next(instance_gen) for i in range(max(0, n_stop) - max(0, n_start))]

    res_range = list(INSTANCE.range(start=n_start, stop=n_stop, n_vars=n_vars))

    assert res_gen == res_range


@settings(deadline=timedelta(seconds=1))
@given(
    n_index=st.integers(min_value=-10, max_value=50),
)
def test_instance_generator_get(n_index: int) -> None:

    n_vars = 2

    instance_gen = iter(instance_map(n_vars))

    for _ in range(0, n_index):
        next(instance_gen)

    res_gen = next(instance_gen)

    res_get = INSTANCE.get(index=n_index, n_vars=n_vars)

    assert res_gen == res_get


def test_instance_generator_card() -> None:

    n_vars = 5

    feat_gen = FEAT_PROG.generator()

    for i, s_tuple in enumerate(feat_gen):
        if i > 100:
            break
        estimated = INSTANCE._cardinality(s_tuple.structure, n_vars)
        actual = len(list(INSTANCE.generator_from_structure(s_tuple, n_vars)))
        assert estimated == actual


@settings(deadline=timedelta(seconds=1))
@given(
    n_vars=st.integers(min_value=1, max_value=10),
    n_start=st.integers(min_value=0, max_value=50),
)
def test_instance_generator_get_eq_range(n_vars: int, n_start: int) -> None:

    res_get = INSTANCE.get(index=n_start, n_vars=n_vars)

    res_range = list(INSTANCE.range(start=n_start, stop=n_start + 1, n_vars=n_vars))[0]

    assert res_get == res_range


@given(
    start=st.integers(min_value=1, max_value=30),
    stop=st.integers(min_value=0, max_value=70),
    samples=st.integers(min_value=1, max_value=60),
)
def test_range_uniform(start: int, stop: int, samples: int) -> None:
    assume(start < stop)
    assume(stop - start >= samples)

    n_vars = 5

    res_range = list(
        INSTANCE.range(start=start, stop=stop, n_vars=n_vars, uniform=samples)
    )

    assert len(res_range) == min(samples, stop - start)
