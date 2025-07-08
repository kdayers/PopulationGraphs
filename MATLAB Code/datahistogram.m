% Set folder containing distance matrix CSV files
folder = "/Users/kimberlyayers/Documents/GitHub/PopulationGraphs"  % <-- Change this path

% Get list of CSV files
files = dir(fullfile(folder, '*.csv'));

filenames = strings(length(files), 1);

C = zeros(1, length(files)*1225);

for k = 1:length(files)
    file_path = fullfile(folder, files(k).name);

    % Read distance matrix, skip header row
    A = readmatrix(file_path, 'NumHeaderLines', 1);
    A = triu(A);
    B = nonzeros(A(:));
    C(1, 1225*(k-1)+1:1225*k)= B;
end

C=C'