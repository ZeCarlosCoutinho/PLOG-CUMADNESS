and(A,B):- A > 0,B > 0.
or(A,B):- A > 0;B > 0.
nand(A,B):- \+and(A,B).
nor(A,B):- \+or(A,B).
xor(A,B):- or(A,B), nand(A,B).