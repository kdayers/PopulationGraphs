function cleanDisconnectedGraphs(folderPath)
    files = dir(fullfile(folderPath, 'adjacencymatrix*.csv'));

    if isempty(files)
        error('No adjacency matrix files found in %s', folderPath);
    end

    fprintf('Checking %d graphs for disconnected nodes...\n\n', length(files));

    for k = 1:length(files)
        fileName = files(k).name;
        fullPath = fullfile(folderPath, fileName);

        % Load adjacency matrix
        A = readmatrix(fullPath);

        % Skip non-square
        if size(A,1) ~= size(A,2)
            warning('Skipping non-square matrix: %s\n', fileName);
            continue;
        end

        % Create graph object
        G = graph(A);

        % Find connected components
        [bins, binSizes] = conncomp(G);

        % If already connected, skip
        if max(bins) == 1
            %fprintf('%s is already connected.\n', fileName);
            continue;
        end

        % Identify the largest connected component
        [~, mainBin] = max(binSizes);
        keepIdx = find(bins == mainBin);
        removeIdx = find(bins ~= mainBin);

        % Notify user
        fprintf('%s is disconnected. Removing %d disconnected node(s): %s\n', ...
            fileName, length(removeIdx), mat2str(removeIdx));

        % Reduce the adjacency matrix
        A_connected = A(keepIdx, keepIdx);

        % Save result
        [~, baseName, ~] = fileparts(fileName);
        outName = fullfile(folderPath, [baseName, '_altered.csv']);
        writematrix(A_connected, outName);

        fprintf('Saved connected graph to: %s\n\n', outName);
    end

    fprintf('Done.\n');
end
