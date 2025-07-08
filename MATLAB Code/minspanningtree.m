A=readmatrix("distancematrix2.csv");
G=graph(A);
T = minspantree(G);
max(T.Edges.Weight)