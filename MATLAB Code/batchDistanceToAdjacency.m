function batchDistanceToAdjacency(cutoff)
%   cutoff     - distance threshold for edge inclusion

    % Get list of all .csv files in folder
    folderPath = 'C:\Users\maxwe\OneDrive\Documents\GitHub\PopulationGraphs';
    folderSavePath = 'C:\Users\maxwe\OneDrive\Documents\graph';
    files = dir(fullfile(folderPath, '*.csv'));

    if isempty(files)
        error('No CSV files found in the specified folder.');
    end

    fprintf('Processing %d files in %s\n', length(files), folderPath);

    for k = 1:length(files)
        % Get file name and path
        fileName = files(k).name;
        fullPath = fullfile(folderPath, fileName);

        % Load distance matrix
        D = readmatrix(fullPath);

        % Check that it’s square
        if size(D,1) ~= size(D,2)
            warning('Skipping non-square matrix: %s', fileName);
            continue;
        end

        % Convert to adjacency matrix
        A = (D <= cutoff) & ~eye(size(D));   % exclude self-edges
        A = double(A | A');                  % make symmetric if needed

        % Construct output filename
        % Replace "distancematrix" with "adjacencymatrix" in the base name
        [~, baseName, ~] = fileparts(fileName);
        adjName = strrep(baseName, 'distancematrix', 'adjacencymatrix');
        outName = fullfile(folderSavePath, [adjName, '.csv']);
        % Save adjacency matrix
        writematrix(A, outName);
        fprintf('Saved: %s\n', outName);
    end

    fprintf('Done.\n');
end
