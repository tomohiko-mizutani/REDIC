function [] = runEndmemberExtraction()

    inData = 'samson';
    metricType = 'mrsa';
    opts.displayFlag = 1; 

    switch inData
        case 'jasper'
            load('../data/real_data/jasper/work/jasper.mat', 'A', 'refIndices', 'endmembers');
            numEms = 4;
            refSigs = A(:, refIndices);
            outFileName = 'jasper_results.mat';

        case 'samson'
            load('../data/real_data/samson/work/samson.mat', 'A', 'refIndices', 'endmembers');
            numEms = 3;
            refSigs = A(:, refIndices);
            outFileName = 'samson_results.mat';

        case 'urban'
            load('../data/real_data/urban/work/urban.mat', 'A', 'refIndices', 'endmembers');
            load('../data/real_data/urban/preprocessing/colsToRemove_40_10.mat', 'colsToRemove');
            numEms = 6;
            refSigs = A(:, refIndices);
            A(:, colsToRemove) = [];
            outFileName = 'urban_results.mat';
    end

    startTime = tic;
    [outIndices, ~, opts] = eeht(A, numEms, opts);
    elapsedTime = toc(startTime);

    [metricValues, correspondance] = evaluateResults(A, refSigs, outIndices, metricType);
    abundanceMaps = getAbundanceMaps(A, refSigs, outIndices, correspondance);

    save(outFileName, 'metricValues', 'abundanceMaps', 'outIndices', 'correspondance', 'elapsedTime', 'opts');

end
