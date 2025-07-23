% Parameters
n = 50;                 % Number of nodes
p = 0.3589;              % Edge probability
num_graphs = 1e6;       % Number of E-R graph iterations

% Preallocate for degree variances
degree_variances = zeros(num_graphs, 1);

% Set RNG for reproducibility
rng(1);

% Start timer
tic;
fprintf('Computing degree variances for %d E-R graphs (n=%d, p=%.3f)...\n', num_graphs, n, p);

% Initialize progress bar
h = waitbar(0, 'Processing graphs...');

for i = 1:num_graphs
    % Generate Erdős-Rényi graph
    G = rand(n, n) < p;
    G = triu(G, 1);
    G = G + G';
    A = sparse(G);

    % Compute node degrees
    degrees = sum(A, 2);  % row-wise sum = degree per node

    % Compute variance of degrees
    degree_variances(i) = var(degrees);

    % Update progress bar every 1000 graphs
    if mod(i, 1000) == 0 || i == num_graphs
        waitbar(i / num_graphs, h, sprintf('Processed %d of %d graphs', i, num_graphs));
    end
end

% Close progress bar
close(h);

% Timer
toc;

% --- Plot Histogram ---

figure;
histogram(degree_variances, 50);  % You can adjust the number of bins
title(sprintf('Histogram of Degree Variances over %d E-R Graphs (n=%d, p=%.3f)', num_graphs, n, p));
xlabel('Variance of Node Degrees');
ylabel('Frequency');
grid on;
