from datetime import timedelta

import hypothesis.strategies as st
from hypothesis import assume, given, settings

import et.main


def is_rgs(l: list[int]) -> bool:
    if l[0] != 1:
        return False

    curr_max_val = 1
    for v in l:
        if v > curr_max_val + 1:
            return False
        curr_max_val = max(curr_max_val, v)
    return True


@settings(deadline=timedelta(seconds=1))
@given(
    amount_var=st.integers(min_value=2, max_value=10),
    max_diff_var=st.integers(min_value=1, max_value=10),
)
def test_rgs(amount_var: int, max_diff_var: int) -> None:

    assume(max_diff_var <= amount_var)

    gen = et.main.generate_variables(amount_var=amount_var, max_diff_var=max_diff_var)

    max_max = -1

    for l in gen:
        assert is_rgs(l)
        ml = max(l)
        max_max = max(max_max, ml)
        assert ml <= max_diff_var

    assert max_max == max_diff_var


if __name__ == "__main__":
    print(et.main.generate_variables(amount_var=1, max_diff_var=2))
