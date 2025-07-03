function adjacencyToGraph(folderPath)
%savePlots  - (optional) if true, saves each plot as a PNG

    if nargin < 2
        savePlots = false;  % default: don't save images
    end

    files = dir(fullfile(folderPath, 'adjacencymatrix*.csv'));

    if isempty(files)
        error('No adjacency matrix CSV files found in folder: %s', folderPath);
    end

    fprintf('Visualizing %d adjacency matrices from %s\n\n', length(files), folderPath);

    for k = 1:length(files)
        fileName = files(k).name;
        fullPath = fullfile(folderPath, fileName);

        % Load adjacency matrix
        A = readmatrix(fullPath);

        % Validate
        if size(A,1) ~= size(A,2)
            warning('Skipping non-square matrix: %s\n', fileName);
            continue;
        end

        % Construct graph object (undirected by default)
        G = graph(A);  % use digraph(A) for directed

        % Create a new figure
        figure('Name', fileName, 'NumberTitle', 'off');

        % Plot the graph
        plot(G, 'Layout', 'force');  % 'force' = force-directed layout

        % Title
        title(strrep(fileName, '_', '\_'), 'Interpreter', 'none');

        % Save figure if requested
        if savePlots
            [~, baseName, ~] = fileparts(fileName);
            saveas(gcf, fullfile(folderPath, [baseName, '_graph.png']));
        end
    end

    fprintf('Done visualizing.\n');
end
