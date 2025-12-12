% [.##.]
line(0,light(0..4)).
:- part(1),line(0,lit(0)).
:- part(1),not line(0,lit(1)).
:- part(1),not line(0,lit(2)).
:- part(1),line(0,lit(3)).
line(0,button(0,(3))).
line(0,button(1,(1;3))).
line(0,button(2,(2))).
line(0,button(3,(2;3))).
line(0,button(4,(0;2))).
line(0,button(5,(0;1))).
% {3,5,4,7}
line(0,jolt(0..4)).
:- part(2),line(0,jolt(0,N)),N!=3.
:- part(2),line(0,jolt(1,N)),N!=5.
:- part(2),line(0,jolt(2,N)),N!=4.
:- part(2),line(0,jolt(3,N)),N!=7.

% [...#.]
line(1,light(0..5)).
:- part(1),line(1,lit(0)).
:- part(1),line(1,lit(1)).
:- part(1),line(1,lit(2)).
:- part(1),not line(1,lit(3)).
:- part(1),line(1,lit(4)).
line(1,button(0,(0;2;3;4))).
line(1,button(1,(2;3))).
line(1,button(2,(0;4))).
line(1,button(3,(0;1;2))).
line(1,button(4,(1;2;3;4))).
% {7,5,12,7,2}
line(1,jolt(0..5)).
:- part(2),line(1,jolt(0,N)),N!=7.
:- part(2),line(1,jolt(1,N)),N!=5.
:- part(2),line(1,jolt(2,N)),N!=12.
:- part(2),line(1,jolt(3,N)),N!=7.
:- part(2),line(1,jolt(4,N)),N!=2.

% [.###.#]
line(2,light(0..6)).
:- part(1),line(2,lit(0)).
:- part(1),not line(2,lit(1)).
:- part(1),not line(2,lit(2)).
:- part(1),not line(2,lit(3)).
:- part(1),line(2,lit(4)).
:- part(1),not line(2,lit(5)).
line(2,button(0,(0;1;2;3;4))).
line(2,button(1,(0;3;4))).
line(2,button(2,(0;1;2;4;5))).
line(2,button(3,(1;2))).
% {10,11,11,5,10,5}
line(2,jolt(0..6)).
:- part(2),line(2,jolt(0,N)),N!=10.
:- part(2),line(2,jolt(1,N)),N!=11.
:- part(2),line(2,jolt(2,N)),N!=11.
:- part(2),line(2,jolt(3,N)),N!=5.
:- part(2),line(2,jolt(4,N)),N!=10.
:- part(2),line(2,jolt(5,N)),N!=5.

