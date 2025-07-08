% Set folder containing distance matrix CSV files
folder = "/Users/kimberlyayers/Documents/GitHub/PopulationGraphs"  % <-- Change this path

% Get list of CSV files
files = dir(fullfile(folder, '*.csv'));

filenames = strings(length(files), 1);

C = zeros(1, length(files));

for k = 1:length(files)
    file_path = fullfile(folder, files(k).name);

    % Read distance matrix, skip header row
    A = readmatrix(file_path, 'NumHeaderLines', 1);
    numcols=size(A,2);
    D=zeros(1,numcols);

    for i = 1:numcols
        D(i)=min(nonzeros(A(:,i)));
    end
    
    C(k)=max(D);
end

C=C';


writematrix(C,"maxmin.csv")