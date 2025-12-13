from sys import stdin
from functools import cache

nodes = {
    name: edges.split()
    for line in stdin.readlines()
    for name, edges in (line.split(": "),)
}


# count paths from "you" node to "out" node
# DFS from "you" to "out" with backtracking to count all paths
# memoize sub-paths
@cache
def pt1(nodename) -> int:
    if nodename == "out":
        return 1
    return sum(pt1(node) for node in nodes[nodename])


print("pt1:", pt1("you"))


# count paths from "svr" to "out" that pass through both "dac" and "fft"
# similar to pt1, but track separate memo value by set of {"dac", "fft"} seen so
# far
@cache
def pt2(nodename: str, seen=frozenset()) -> int:
    if nodename == "out":
        return 1 if seen == {"dac", "fft"} else 0
    return sum(
        pt2(node, seen | {nodename} if nodename in {"dac", "fft"} else seen)
        for node in nodes[nodename]
    )


print("pt2:", pt2("svr"))
