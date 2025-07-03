function batchGraphProperties(folderPath)
%folderPath - string path to folder containing adjacency matrix CSV files

    % Get list of all CSV files
    files = dir(fullfile(folderPath, 'adjacencymatrix*.csv'));

    if isempty(files)
        error('No adjacency matrix CSV files found in folder: %s', folderPath);
    end

    fprintf('Analyzing %d adjacency matrices from %s\n\n', length(files), folderPath);

    for k = 1:length(files)
        fileName = files(k).name;
        fullPath = fullfile(folderPath, fileName);

        % Read adjacency matrix
        A = readmatrix(fullPath);

        % Validate square binary matrix
        if size(A,1) ~= size(A,2)
            warning('Skipping non-square matrix: %s\n', fileName);
            continue;
        end

        % Compute graph properties
        try
            [L, EGlob, CClosed, ELocClosed, COpen, ELocOpen] = graphProperties(A);

            % Print results
            fprintf('--- %s ---\n', fileName);
            fprintf('Characteristic Path Length (L): %.4f\n', L);
            %fprintf('Global Efficiency (EGlob):      %.4f\n', EGlob);
            fprintf('Clustering (Closed) (CClosed):  %.4f\n', CClosed);
            %fprintf('Local Eff. (Closed) (ELocClosed): %.4f\n', ELocClosed);
            fprintf('Clustering (Open) (COpen):      %.4f\n', COpen);
            %fprintf('Local Eff. (Open) (ELocOpen):   %.4f\n\n', ELocOpen);

        catch ME
            warning('Error processing %s: %s\n', fileName, ME.message);
        end
    end

    fprintf('Done.\n');
end
