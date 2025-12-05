% this doesn't work because clingo (gringo) silently wraps around ints greater than 32 bits
% run gringo -t on the full input to see the negative ints generated
% using strings for the numbers doesn't work because they are legxiographically ordered
fresh(X) :- id(X), range(A,B), A <= X <= B.

fresh_count(N):-N=#count{X: fresh(X)}.
#show fresh_count/1.
