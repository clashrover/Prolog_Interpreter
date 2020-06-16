edge(a,b).
edge(b,c).
edge(c,a).

connected(X1,Y1) :- edge(X1,Y1).
connected(X2,Y2) :- edge(X2,Z2),connected(Z2,Y2).
