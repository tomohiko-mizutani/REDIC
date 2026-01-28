clear;

inData = 'jasper'; % 'jasper', 'samson', 'urban'
% opts.numPartitions = 10;

if ~exist('opts', 'var')
    opts = struct();
end

defaultOpts = getDefaultDrsOpts();
opts = setOpts(opts, defaultOpts);

switch inData

    case 'jasper'
        load('../data/real_data/jasper.mat', 'A', 'refIndices', 'endmembers');

        dataName = "Jasper Ridge";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);

    case 'samson'
        load('../data/real_data/samson.mat', 'A', 'refIndices', 'endmembers');

        dataName = "Samson";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);

    case 'urban'
        load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers');
        load('../data/real_data/colsToRemove_40_10.mat', 'colsToRemove');

        dataName = "Urban";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);
        A(:, colsToRemove) = [];

end

startTime = tic;
[~, S, V] = svds(A, numEms, 'largest');
A_dimReduced = S * V';
boundaryIndices = drs(A_dimReduced, opts);
elapsedTime = toc(startTime);

[minDistances, ~] = getMinDistances(A(:, boundaryIndices), refSigs, 'mrsa');
reValue = getReValue(A_dimReduced, A_dimReduced(:, boundaryIndices));

fprintf('=== Results for %s dataset === \n', dataName);
fprintf('Number of elements in the obtained set:  %d \n', numel(boundaryIndices));
fprintf('MRSA distance:                           %3.2f \n', mean(minDistances));
fprintf('Reconstruction error:                    %3.2e \n', reValue);
fprintf('Elapsed time:                            %.2f s \n', elapsedTime);
