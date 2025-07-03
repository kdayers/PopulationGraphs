function countInducedFourCycles(A)
    n=size(A);
        count = 0;

        % Brute-force over all 4-node combinations
        combos = nchoosek(1:n, 4);
        for i = 1:size(combos, 1)
            nodes = combos(i, :);
            subA = A(nodes, nodes);

            % Count edges in subgraph
            num_edges = nnz(triu(subA));

            % Check for induced 4-cycle
            if num_edges == 4
                degrees = sum(subA, 2);
                if all(degrees == 2)
                    count = count + 1;
                end
            end
        end
        fprintf('Graph %d: %d induced 4-cycles\n', 1, count);

end
