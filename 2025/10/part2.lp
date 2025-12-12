#const n=50.
part(2).
:- line(L,jolt(N)), not line(L,jolt(N,_)).
line(Line,jolt(L,S)) :- line(Line,jolt(L)), S=#sum{N,B: line(Line,press(B,N)), line(Line,button(B,L))}.
{ line(Line,press(B,0..n)) } 1 :- line(Line,button(B,_)).
#minimize{N,L,B: line(L,press(B,N))}.
#show line(Line,press(B,N)): line(Line,press(B,N)).
#show.
