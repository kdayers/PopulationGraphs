function adjacencyMatrix = csv_to_adjacency(filename)
    % Reads a CSV file with an edge list and returns an adjacency matrix.
    % Automatically removes a header row if it's not numeric.

    % Read file as cell array
    rawData = readcell(filename);

    % Try converting first row to numbers
    firstRow = rawData(1,1:2);
    firstRowNumeric = cellfun(@str2double, firstRow);

    if any(isnan(firstRowNumeric))
        % First row is not numeric, treat it as header
        data = rawData(2:end, 1:2);
    else
        data = rawData(:, 1:2);
    end

    % Convert to numeric, catching conversion errors
    try
        source = cellfun(@str2double, data(:,1));
        target = cellfun(@str2double, data(:,2));
    catch
        error('Error converting edge list to numeric. Make sure the first two columns contain node numbers.');
    end

    % Sanity check
    if any(isnan(source)) || any(isnan(target))
        error('Edge list contains non-numeric values in node columns.');
    end

    % Determine number of nodes
    numNodes = max([source; target]);

    % Initialize adjacency matrix
    adjacencyMatrix = zeros(numNodes);

    % Build matrix
    for i = 1:length(source)
        adjacencyMatrix(source(i), target(i)) = 1;
        % Uncomment for undirected graphs:
        adjacencyMatrix(target(i), source(i)) = 1;
    end

    % Display
    disp('Adjacency Matrix:');
    disp(adjacencyMatrix);
end
