% Parameters
n = 50;                 % Number of nodes
p = 0.135;                % Edge probability
num_graphs = 1e3;        % Total number of graphs

% Preallocate for CClosed values
CClosed_values = zeros(num_graphs, 1);
valid_count = 0;

% Set RNG for reproducibility
rng(1);

% Start timer
tic;
fprintf('Computing median closed clustering coefficient for %d E-R graphs...\n', num_graphs);

% Initialize progress bar
h = waitbar(0, 'Processing graphs...');

for i = 1:num_graphs
    % Generate Erdős-Rényi graph
    G = rand(n, n) < p;
    G = triu(G, 1);
    G = G + G';
    A = sparse(G);

    % Compute CClosed
    try
        [~, ~, CClosed, ~, ~, ~] = graphProperties(A);
        if ~isnan(CClosed) && isfinite(CClosed)
            valid_count = valid_count + 1;
            CClosed_values(valid_count) = CClosed;
        end
    catch
        continue;
    end

    % Update progress bar every 1000 iterations
    if mod(i, 1000) == 0 || i == num_graphs
        waitbar(i / num_graphs, h, sprintf('Processing graph %d of %d', i, num_graphs));
    end
end

% Close progress bar
close(h);

% Trim and compute median
CClosed_values = CClosed_values(1:valid_count);
median_CClosed = median(CClosed_values);

% Display result
fprintf('\nMedian Closed Clustering Coefficient over %d valid E-R graphs (n=%d, p=%.2f): %.6f\n', ...
        valid_count, n, p, median_CClosed);

% Timer
toc;
