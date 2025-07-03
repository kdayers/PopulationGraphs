function csvHistogram(file)
    % Read data from CSV file
    data = csvread(file);
    
    % Plot histogram
    figure;
    histogram(data, 'BinMethod', 'auto'); % 'auto' chooses bin width automatically
    xlabel('Number of Cycles');
    ylabel('Frequency');
    title('Histogram of Cycles in Erdős–Rényi Graphs');
    grid on;
    print -deps epsFig
end