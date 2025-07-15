% Set folder containing distance matrix CSV files
folder = '/Users/kimberlyayers/Documents/GitHub/PopulationGraphs';  % <-- Change this path

% Get list of CSV files
files = dir(fullfile(folder, '*.csv'));

% Initialize storage
max_edge_weights = zeros(length(files), 1);
filenames = strings(length(files), 1);

for k = 1:length(files)
    file_path = fullfile(folder, files(k).name);

    % Read distance matrix, skip header row
    A = readmatrix(file_path,'NumHeaderLines', 1);

    % Optional: replace diagonal with Inf to avoid self-loops
    A(1:size(A,1)+1:end) = inf;

    % Construct full graph from matrix
    G = graph(A);

    % Compute MST
    T = minspantree(G);

    % Record the maximum edge weight in the MST
    max_edge_weights(k) = max(T.Edges.Weight);
    filenames(k) = files(k).name;

    fprintf('%s: max MST edge = %.6f\n', files(k).name, max_edge_weights(k));
end
for k = 1:length(files)
    file_path = fullfile(folder, files(k).name);

    try
        % Read distance matrix, skip header
        A = readmatrix(file_path, 'NumHeaderLines', 1);

        % Check if matrix is square
        [rows, cols] = size(A);
        if rows ~= cols
            error('Matrix is not square.');
        end

        % Replace diagonal with Inf to avoid self-loops
        A(1:size(A,1)+1:end) = inf;

        % Construct graph
        G = graph(A);

        % Compute MST
        T = minspantree(G);

        % Store result
        max_edge_weights(k) = max(T.Edges.Weight);
        filenames(k) = files(k).name;


    catch ME
        fprintf('ERROR in %s: %s\n', files(k).name, ME.message);
    end
end

% Display average
avg_max_edge = mean(max_edge_weights);
fprintf('\nAverage of max MST edges across %d files: %.6f\n', length(files), avg_max_edge);

% Plot histogram of max edge weights
figure;
histogram(max_edge_weights, 'NumBins', 20, 'EdgeColor', 'black', 'FaceColor', [0.2 0.4 0.6]);
xlabel('Maximum Edge Weight in MST');
ylabel('Frequency');
title('Histogram of Max MST Edge Weights');
grid on;

writematrix(max_edge_weights,"maxedgeweights.csv")