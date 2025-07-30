function folderInput_ClusterCoeff_ComputeCharPathLength(folder_path)
    % Get all CSV files in the folder
    files = dir(fullfile(folder_path, '*.csv'));
    num_files = length(files);

    if num_files == 0
        error('No adjacency matrix CSV files found in %s', folder_path);
    end

    % Preallocate for metrics
    CClosed_values = zeros(num_files, 1);
    L_values = zeros(num_files, 1);

    valid_count = 0;

    % Timer
    fprintf('Processing %d graphs in: %s\n', num_files, folder_path);
    tic;

    for i = 1:num_files
        file_name = files(i).name;
        full_path = fullfile(folder_path, file_name);

        try
            % Load adjacency matrix
            A = readmatrix(full_path);
            A = sparse(A);

            % Create graph object
            G = graph(A);

            % Get connected components
            [bins, binSizes] = conncomp(G);
            if max(bins) > 1
                % Keep only the largest component
                [~, mainBin] = max(binSizes);
                keepIdx = find(bins == mainBin);
                A = A(keepIdx, keepIdx);
            end

            % Compute graph properties
            [L, ~, CClosed, ~, ~, ~] = graphProperties(A);

            % Store only if both metrics are valid
            if isfinite(CClosed) && isfinite(L)
                valid_count = valid_count + 1;
                CClosed_values(valid_count) = CClosed;
                L_values(valid_count) = L;
            end
        catch ME
            fprintf('Skipping %s: %s\n', file_name, ME.message);
            continue;
        end

        % Optional progress
        if mod(i, 100) == 0 || i == num_files
            fprintf('Processed %d / %d\n', i, num_files);
        end
    end

    % Trim to valid entries
    CClosed_values = CClosed_values(1:valid_count);
    L_values = L_values(1:valid_count);

    % Combine into 2D matrix and save
    results = [CClosed_values, L_values];
    writematrix(results, 'graph_metrics.csv');

    % Display summary
    fprintf('\nSaved %d valid graph metrics to graph_metrics.csv\n', valid_count);
    fprintf('Median Clustering Coefficient: %.6f\n', median(CClosed_values));
    fprintf('Median Characteristic Path Length: %.6f\n', median(L_values));
    toc;
end
