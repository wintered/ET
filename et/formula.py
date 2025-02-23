import math
from copy import deepcopy
from functools import cache
from pprint import pprint

import et.main as main


@cache
def rgs(l: int, pos: int) -> int:
    assert l > pos
    if l == 1:
        return 1

    s = 0
    for j in range(max(0, pos - 1), l - 1):
        s += rgs(l - 1, j)
    # print(f"{l=} {pos=} {s=}")
    return s


def total_rgs(l: int) -> int:
    return rgs(l + 1, 0)


def is_rgs(l: list[int]) -> bool:
    if l[0] != 1:
        return False

    curr_max_val = 1
    for v in l:
        if v > curr_max_val + 1:
            return False
        curr_max_val = max(curr_max_val, v)
    return True


def fac(n: int) -> int:
    if n == 0:
        return 0
    if n == 1:
        return 1
    f = 1
    for i in range(1, n + 1):
        f *= i
    return f


def sterling(n: int, k: int) -> int:
    if n == k:
        return 1
    s: int = 0
    for i in range(k + 1):
        # upper = ((-1)**(k-i)*(i**n))
        # lower = math.comb(k,i)//math.factorial(k) #(fac(k-i)*fac(i))
        # s += upper/lower
        s += (-1) ** (k - i) * math.comb(k, i) * i**n
    s = s // fac(k)
    return s


def rgs_sterling(n_vars: int, n_max_diff_vars: int) -> int:
    s = 0
    for k in range(1, min(n_vars + 1, n_max_diff_vars + 1)):
        s += sterling(n_vars, k)
    return s


def zeros(n: int) -> list[list[int]]:
    return [[0] * n for _ in range(n)]


def zeros3d(n: int, m: int, k: int) -> list[list[list[int]]]:
    ok = [[0] * n for _ in range(m)]
    return [deepcopy(ok) for _ in range(k)]


def md(l: int, n_max_diff_vars: int) -> int:
    # Max digit possible at lenght l
    return min(l - 1, n_max_diff_vars)


def v3(n_vars: int, n_max_diff_vars: int, debug: bool = False) -> list[list[list[int]]]:

    n_vars += 2  # +1 for starting at M[1], +1 for being off-by-one somehow
    # Setup
    M = zeros3d(n_max_diff_vars, n_max_diff_vars, n_vars)

    # init M^1_{0,0} = 1
    M[1][0][0] = 1

    for l in range(2, n_vars):
        m = md(l, n_max_diff_vars)
        for i in range(m):  # Max i in string
            for j in range(i + 1):  # Ending in digit j

                if i == j and i > 0:
                    M[l][i][j] += sum(M[l - 1][i - 1][:m])

                M[l][i][j] += sum(M[l - 1][i][:m])

        if debug:
            print(f"{l=} {m=}")
            pprint(M[l])
    return M


def rgs_recursive(n_vars: int, n_max_diff_vars: int, debug: bool = False) -> int:
    s = 0
    M = v3(n_vars, n_max_diff_vars, debug=debug)
    for v in M[-1]:
        s += sum(v)
    return s


CACHE_S_CUMSUM_TOTAL: list[int] = []
CACHE_S_CUMSUM_PER_LEVEL: dict[int, list[int]] = {}


def populate() -> None:
    # print("Populating")
    global CACHE_S_CUMSUM_TOTAL
    global CACHE_S_CUMSUM_PER_LEVEL

    l_idx = len(CACHE_S_CUMSUM_TOTAL)
    l = l_idx + 1

    CACHE_S_CUMSUM_PER_LEVEL[l_idx] = []
    # Generate stirling

    stir_accu = 0
    for k in range(1, l + 1):
        stir_accu += sterling(l, k)
        CACHE_S_CUMSUM_PER_LEVEL[l_idx].append(stir_accu)

    prev = 0
    if len(CACHE_S_CUMSUM_TOTAL) > 0:
        prev = CACHE_S_CUMSUM_TOTAL[-1]
    CACHE_S_CUMSUM_TOTAL.append(prev + stir_accu)


def reconstruct(idx: int) -> list[int]:
    global CACHE_S_CUMSUM_TOTAL
    global CACHE_S_CUMSUM_PER_LEVEL
    if len(CACHE_S_CUMSUM_TOTAL) == 0:
        populate()

    idx += 1  # Shift to start counting from one

    # Dumb linear search to find the length

    l_idx = 0

    while idx > CACHE_S_CUMSUM_TOTAL[-1]:
        # Have not cached enough yet
        populate()

    while idx > CACHE_S_CUMSUM_TOTAL[l_idx]:
        l_idx += 1

    # import pdb; pdb.set_trace()

    idx -= CACHE_S_CUMSUM_TOTAL[l_idx - 1] if l_idx > 0 else 0

    res = []
    # import pdb; pdb.set_trace()
    while l_idx >= 0:
        cumsum_level = CACHE_S_CUMSUM_PER_LEVEL[l_idx]

        intra_lvl_idx = 0
        # Extract
        print(f"{intra_lvl_idx=}")
        while intra_lvl_idx < len(cumsum_level) and idx > cumsum_level[intra_lvl_idx]:
            print(f"{idx=}, {intra_lvl_idx=}, {cumsum_level=}")
            intra_lvl_idx += 1

        res.append(intra_lvl_idx)
        diff = cumsum_level[intra_lvl_idx - 1] if intra_lvl_idx > 0 else 0
        idx -= diff
        print(
            f"{res=}, {diff=}, {idx=}, {l_idx=}, {CACHE_S_CUMSUM_PER_LEVEL[l_idx]=} {CACHE_S_CUMSUM_TOTAL[l_idx]=}"
        )
        l_idx -= 1

    assert idx == 0 or idx == 1
    res.reverse()
    # print(res)
    return res


@cache
def tree_size(l: int, prev_mx: int, max_diff_vars: int) -> int:
    if l < 1:
        return 0
    if l == 1:
        return 1
    return sum(
        tree_size(l - 1, max(prev_mx, i), max_diff_vars)
        for i in range(min(max_diff_vars, prev_mx + 2))
    )


def reconstruct_v2(idx: int, max_diff_vars: int) -> list[int]:
    # find length

    l = 1
    el_accu = tree_size(l, 0, max_diff_vars)
    while idx > el_accu:
        l += 1
        el_accu += tree_size(l, 0, max_diff_vars)

    res = [0]
    idx += tree_size(l, 0, max_diff_vars)
    idx -= el_accu + 1

    while len(res) < l:
        curr_max = max(res) if res else 0
        l_rest = l - len(res)
        for i in range(curr_max + 1 + 1):
            yeah = tree_size(l_rest, max(i, curr_max), max_diff_vars)
            if yeah > idx:
                res.append(i)
                break
            idx -= yeah

    return res


if __name__ == "__main__":
    N_MAX_DIFF_VARS = 6

    start = 1

    # for i in range(1, 5):
    #    for j in range(0,i+1):
    #        print(i,j, ok(i, j))

    # print("---------------------")
    # print("res", reconstruct_v2(13))

    # print("---------------------")
    #
    # print("res", reconstruct_v2(22))
    # print("res", reconstruct_v2(16))

    # s = set()
    # for idx in range(8, 25):
    #    g = tuple(reconstruct_v2(idx))
    #    if g == (0,1,0,0):
    #        print("FOUND", idx)
    #    if g in s:
    #        print("DUplicate found", idx, g)
    #        break
    #    s.add(g)

    # for l in range(1,100):
    #    print(l)
    #    gen = main.generate_variables(amount_var=l, max_diff_var=l)
    #
    #    og = set(tuple(s) for s in gen)

    #    print("gen done")

    #    new = set()
    #    new_l = []
    #    for idx in range(start, start+len(og)):
    #        g = reconstruct_v2(idx)
    #        g = [k+1 for k in g]

    #        new_l.append(g)
    #        new.add(tuple(g))
    #    start += len(og)
    #    print("New done")
    #    if not og == new:
    #        print(og)
    #        print(new)
    #        print(new_l)
    #        print(og - new)
    #        break

    count = 1
    max_diff_vars = 5
    for i in range(1, 10):
        gen = main.generate_variables(amount_var=i, max_diff_var=max_diff_vars)
        for r in gen:
            con = [k + 1 for k in reconstruct_v2(count, max_diff_vars)]
            if not (tuple(r) == tuple(con)):
                print(r, con)
            count += 1

    # print(f"{reconstruct_v2(10**200)=}")

    # print(reconstruct_v2(10**100))

    # print(ok(3,0))
    # print(ok(3,0) - ok(2,0))

    # print(sum(ok(i,0) for i in range(1,4)))

    # print(ok(2, 0), ok(1, 0))
    # print(ok(2, 1), ok(1, 1))

    # print(reconstruct(7))
    # for i in range(1, 8):
    #    # print("----------", i)
    #    # print(i, reconstruct(i))
    #    continue

    # for i in range(10):
    #    populate()
    # pprint(CACHE_S_CUMSUM_TOTAL)
    # pprint(CACHE_S_CUMSUM_PER_LEVEL)

    # for n_vars in range(1, 1000):
    #    #gen = main.generate_variables(amount_var=n_vars, max_diff_var=N_MAX_DIFF_VARS)
    #    gen = []
    #    ster = rgs_sterling(n_vars, N_MAX_DIFF_VARS)
    #    recur = rgs_recursive(n_vars, N_MAX_DIFF_VARS, debug=False)

    #    print(n_vars, len(gen), ster, recur)
