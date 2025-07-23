function compare_three_cycles_ER_PopGraphs(dir1, dir2)
    % List CSV files in each directory
    files1 = dir(fullfile(dir1, '*.csv'));
    files2 = dir(fullfile(dir2, '*.csv'));

    if length(files1) ~= length(files2)
        warning('Directories contain different number of matrices.');
    end

    num_files = min(length(files1), length(files2));
    three_cycles_1 = zeros(1, num_files);
    three_cycles_2 = zeros(1, num_files);

    % Loop through each pair of files
    for i = 1:num_files
        A1 = readmatrix(fullfile(dir1, files1(i).name));
        A2 = readmatrix(fullfile(dir2, files2(i).name));

        % Ensure matrices are square
        if ~isequal(size(A1,1), size(A1,2)) || ~isequal(size(A2,1), size(A2,2))
            error('Non-square matrix detected in file: %s or %s', ...
                files1(i).name, files2(i).name);
        end

        % Count 3-cycles (triangles): trace(A^3) / 6
        three_cycles_1(i) = trace(A1^3) / 6;
        three_cycles_2(i) = trace(A2^3) / 6;
    end

    % Plot histograms
    figure;
    subplot(1, 2, 1);
    histogram(three_cycles_1, 'FaceColor', [0.2, 0.6, 1]);
    title('3-Cycles in Graphs from Directory 1');
    xlabel('Number of 3-Cycles');
    ylabel('Frequency');

    subplot(1, 2, 2);
    histogram(three_cycles_2, 'FaceColor', [1, 0.4, 0.4]);
    title('3-Cycles in Graphs from Directory 2');
    xlabel('Number of 3-Cycles');
    ylabel('Frequency');
end
