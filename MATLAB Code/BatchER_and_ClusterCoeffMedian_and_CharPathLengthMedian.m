% Parameters
n = 50;                 % Number of nodes
p = 0.3589;                % Edge probability
num_graphs = 1e6;        % Total number of graphs

% Preallocate arrays for metrics (max size = num_graphs)
CClosed_values = zeros(num_graphs, 1);
L_values = zeros(num_graphs, 1);

valid_count = 0;

% Set RNG for reproducibility
rng(1);

% Start timer
tic;
fprintf('Computing median closed clustering coefficient and characteristic path length for %d E-R graphs...\n', num_graphs);

% Initialize progress bar
h = waitbar(0, 'Processing graphs...');

for i = 1:num_graphs
    % Generate Erdős-Rényi graph
    G = rand(n, n) < p;
    G = triu(G, 1);
    G = G + G';
    A = sparse(G);

    % Compute graph properties
    try
        [L, ~, CClosed, ~, ~, ~] = graphProperties(A);

        % Check if BOTH are valid
        if ~isnan(CClosed) && isfinite(CClosed) && ~isnan(L) && isfinite(L)
            valid_count = valid_count + 1;
            CClosed_values(valid_count) = CClosed;
            L_values(valid_count) = L;
        end
    catch
        % Skip graphs causing errors
        continue;
    end

    % Update progress bar every 1000 iterations or at the end
    if mod(i, 1000) == 0 || i == num_graphs
        waitbar(i / num_graphs, h, sprintf('Processed %d of %d graphs', i, num_graphs));
    end
end

% Close progress bar
close(h);

% Trim arrays to valid entries only
CClosed_values = CClosed_values(1:valid_count);
L_values = L_values(1:valid_count);

% Compute medians
median_CClosed = median(CClosed_values);
median_L = median(L_values);

% Display results
fprintf('\nMedian Closed Clustering Coefficient over %d valid graphs (n=%d, p=%.3f): %.6f\n', ...
    valid_count, n, p, median_CClosed);
fprintf('Median Characteristic Path Length over %d valid graphs (n=%d, p=%.3f): %.6f\n', ...
    valid_count, n, p, median_L);

% Timer
toc;

% --- Plot Histograms ---

figure;

subplot(2,1,1)
histogram(CClosed_values, 50)  % 50 bins, adjust if you want
title('Histogram of Closed Clustering Coefficient')
xlabel('Closed Clustering Coefficient')
ylabel('Frequency')
grid on

subplot(2,1,2)
histogram(L_values, 50)
title('Histogram of Characteristic Path Length')
xlabel('Characteristic Path Length')
ylabel('Frequency')
grid on
