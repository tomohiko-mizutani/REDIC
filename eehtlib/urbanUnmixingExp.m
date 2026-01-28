function [] = urbanUnmixingExp(preprocOpt, opts)

    metricType = 'mrsa'; % 'mrsa' or 'sad'

    switch preprocOpt

        case 1
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers', 'colsToRemove_40_10');
            colsToRemove = colsToRemove_40_10;
            outFileName = 'urbanUnmixing_preproc1_results.mat';

        case 2
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers', 'colsToRemove_45_15');
            colsToRemove = colsToRemove_45_15;
            outFileName = 'urbanUnmixing_preproc2_results.mat';

        case 3
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers', 'colsToRemove_50_30');
            colsToRemove = colsToRemove_50_30;
            outFileName = 'urbanUnmixing_preproc3_results.mat';

        case 4
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers', 'colsToRemove_55_45');
            colsToRemove = colsToRemove_55_45;
            outFileName = 'urbanUnmixing_preproc4_results.mat';

        case 5
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers', 'colsToRemove_60_60');
            colsToRemove = colsToRemove_60_60;
            outFileName = 'urbanUnmixing_preproc5_results.mat';
    end

    numEms = length(refIndices);
    refSigs = A(:, refIndices);
    A_original = A;
    A(:, colsToRemove) = [];

    startTime = tic;
    [outIndices, ~, opts] = eeht(A, numEms, opts);
    elapsedTime = toc(startTime);

    [metricValues, estSigs] = evaluateMetricValues(A, refSigs, outIndices, metricType);
    abundanceMaps = getAbundanceMaps(A_original, refSigs, estSigs);

    save(outFileName, 'metricValues', 'abundanceMaps', 'outIndices', 'elapsedTime', 'opts');

end
