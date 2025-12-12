#const n=5.
part(1).
line(Line,toggles(L,S)) :- line(Line,light(L)), S=#sum{N,B: line(Line,press(B,N)), line(Line,button(B,L))}.
line(Line,lit(L)) :- line(Line,toggles(L,S)), S \ 2 == 1.
{ line(Line,press(B,N)): N=0..n } 1 :- line(Line,button(B,_)).
#minimize{N,L,B: line(L,press(B,N))}.
#show line(Line,press(B,N)): line(Line,press(B,N)).
#show.
