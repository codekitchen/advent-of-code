pos(0,50).
pos(X+1,((S+T)\100+100)\100):-pos(X,S),turn(X+1,T).

zeros(X,N):-pos(X-1,A),turn(X,T),T>0, N=(T+A)/100.
zeros(X,N):-pos(X-1,A1),turn(X,T),T<0,A=(100-A1)\100, N=(-T+A)/100.

zeros(Total):-Total=#sum{N,X: zeros(X,N)}.
#show zeros/1.
