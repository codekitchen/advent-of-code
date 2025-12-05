from sys import stdin

rangelist, idlist = stdin.read().split("\n\n")
for lower, upper in (line.split("-") for line in rangelist.splitlines()):
    print(f"range({lower}, {upper}).")
for id in idlist.splitlines():
    print(f"id({id}).")
