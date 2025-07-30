function S = calculate_small_worldness(real_csv, random_csv)
    % Load CSVs
    real_data = readmatrix(real_csv);
    rand_data = readmatrix(random_csv);

    % Extract clustering coefficients and path lengths
    C_real = real_data(:, 1);
    L_real = real_data(:, 2);
    C_rand = rand_data(:, 1);
    L_rand = rand_data(:, 2);

    % Compute averages
    C = mean(C_real);
    L = mean(L_real);
    C_rand_avg = mean(C_rand);
    L_rand_avg = mean(L_rand);

    % Check for divide-by-zero
    if C_rand_avg == 0 || L_rand_avg == 0
        error('Random graph clustering or path length is zero. Cannot compute small-worldness.');
    end

    % Compute small-worldness
    S = (C / C_rand_avg) / (L / L_rand_avg);

    % Display results
    fprintf('Real Network:     Avg C = %.5f, Avg L = %.5f\n', C, L);
    fprintf('Random Graphs:    Avg C_rand = %.5f, Avg L_rand = %.5f\n', C_rand_avg, L_rand_avg);
    fprintf('Small-worldness S = %.5f\n', S);
end
