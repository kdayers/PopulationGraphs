% Parameters
n = 50;              % number of nodes
p = 0.3589;             % probability of edge
numGraphs = 100;      % number of ER graphs
outputDir = 'C:\Users\maxwe\OneDrive\Documents\graph\adjMatricesERGraphs-p_0.3589';  % output folder


% Generate and save ER graphs
for i = 1:numGraphs
    % Create random adjacency matrix (no self-loops)
    A = rand(n) < p;
    A = triu(A,1);         % upper triangle only to avoid double edges
    A = A + A';            % make symmetric (undirected graph)
    
    % Save to CSV
    filename = sprintf('er_graph_%03d.csv', i);
    filepath = fullfile(outputDir, filename);
    writematrix(A, filepath);
    
    fprintf('Saved %s\n', filepath);
end