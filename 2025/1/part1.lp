pos(0,50).
pos(X+1,((S+T)\100+100)\100):-pos(X,S),turn(X+1,T).

zeros(N):-N=#count{X: pos(X,0)}.
#show zeros/1.
