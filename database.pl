edge(a,b).
edge(b,c).
edge(c,d).
edge(c,e).

path(X1,Y1) :- edge(X1,Y1).
path(X2,Y2) :- edge(X2,Z2),path(Z2,Y2).
