% Parameters
n = 50;                 % Number of nodes
p = 0.135;                % Edge probability
num_graphs = 1e3;        % Total number of graphs

% Preallocate to store L values (characteristic path lengths)
L_values = zeros(num_graphs, 1);

% Set RNG for reproducibility
rng(1);

% Timer start
tic;
fprintf('Computing median characteristic path length for %d E-R graphs...\n', num_graphs);

valid_count = 0;

for i = 1:num_graphs
    % Generate Erdos-Renyi graph
    G = rand(n, n) < p;
    G = triu(G, 1);
    G = G + G';
    A = sparse(G);

    % Compute characteristic path length
    try
        [L, ~, ~, ~, ~, ~] = graphProperties(A);
        if ~isnan(L) && isfinite(L)
            valid_count = valid_count + 1;
            L_values(valid_count) = L;
        end
    catch
        continue;  % skip disconnected or bad graphs
    end

    % Optional progress output
    if mod(i, 1e5) == 0
        fprintf('Processed %d graphs...\n', i);
    end
end

% Trim unused slots (if any graphs were skipped)
L_values = L_values(1:valid_count);

% Compute median
median_L = median(L_values);

% Display result
fprintf('\nMedian Characteristic Path Length over %d valid E-R graphs (n=%d, p=%.2f): %.6f\n', ...
        valid_count, n, p, median_L);

% Time
toc;
