function [G,n,m] = Erdos_Renyi_Graph(n,p,seed,format,opt)
%% 
%    Description:
%        this function create Erdos-Renyi random Graph*
%    Author: 
%        X.C.
%    Date: 
%        Oct 25 2016
%    Comment:
%        *This code only generate approximately Erdos-Renyi Random Graph. 
%        Since Erdos-Renyi Model only consider the undirected, non-self-loop
%        graphs. However, this code would firstly create a directed graph with,
%        self-loops. And then transform the directed graph into undirected simply
%        by ignore the upper triangular adjacency matrix and delete the self-loops
%        
%        However, when the graph size n is large enough, the generated graph would
%        approximately similar to the expected Erdos-Renyi Model.
%    Output Arguments:
%        G : generated random graph
%        n : graph size, number of vertexes, |V|
%        m : graph size, number of edges, |E|
%    Input Arguments:
%        n : graph size, number of vertexes, |V|
%        p : the probability p of the second definition of Erdos-Renyi model.
%        seed: seed of the function. 
%        format:
%        opt:
% 
G=rand(n,n) < p;
G = triu(G,1);
G = G+ G';
end