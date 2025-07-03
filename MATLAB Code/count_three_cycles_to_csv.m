function count_three_cycles_to_csv(n, p, num_graphs, filename)
    % Function to generate multiple Erdős–Rényi graphs, count 3-cycles, and save to CSV
    % 
    % Inputs:
    %   n - Number of vertices
    %   p - Edge probability
    %   num_graphs - Number of graphs to generate
    %   filename - Name of the CSV file to save results
    %
    % Outputs:
    %   Saves the results as a CSV file
    
    three_cycle_counts = zeros(num_graphs, 1); % Preallocate results
    
    for i = 1:num_graphs
        % Generate an Erdős–Rényi graph without a fixed seed
        A = Erdos_Renyi_Graph(n, p, randi(2^32), 1);
        
        % Compute number of 3-cycles
        three_cycles = trace(A^3) / 6;
        
        % Store the result
        three_cycle_counts(i) = three_cycles;
        
        % Display the result
        fprintf('Graph %d: %d three-cycles\n', i, three_cycles);
    end
    
    % Save results to CSV file
    csvwrite(filename, three_cycle_counts);
    fprintf('Results saved to %s\n', filename);
end