function [] = redicExp(inData, numTrials, seed_redicExp, redicOpts)

    startTimeExp = tic;

    defaultRedicOpts = getDefaultRedicOpts();
    redicOpts = setOpts(redicOpts, defaultRedicOpts);

    eehtOpts = struct();

    switch inData

        case 'jasper'
            load('../data/real_data/jasper.mat', 'A', 'refIndices', 'endmembers');

            dataName = "Jasper Ridge";
            refSigs = A(:, refIndices);
            numEms = length(refIndices);
            dataName = "Jasper Ridge";
            outFileName = "redicExp_jasper_" ...
                + num2str(numTrials) + "_" + num2str(redicOpts.numEehtRuns) + "_" ...
                + num2str(redicOpts.augSetSize) + "_" + num2str(seed_redicExp) + "_results.mat";

        case 'samson'
            load('../data/real_data/samson.mat', 'A', 'refIndices', 'endmembers');

            dataName = "Samson";
            refSigs = A(:, refIndices);
            numEms = length(refIndices);
            dataName = "Samson";
            outFileName = "redicExp_samson_" ...
                + num2str(numTrials) + "_" + num2str(redicOpts.numEehtRuns) + "_" ...
                + num2str(redicOpts.augSetSize) + "_" + num2str(seed_redicExp) + "_results.mat";

        case 'urban'
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers');
            load('../data/real_data/colsToRemove_40_10.mat', 'colsToRemove');

            dataName = "Urban";
            refSigs = A(:, refIndices);
            numEms = length(refIndices);
            A(:, colsToRemove) = [];
            dataName = "Urban";
            outFileName = "redicExp_urban_" ...
                + num2str(numTrials) + "_" + num2str(redicOpts.numEehtRuns) + "_" ...
                + num2str(redicOpts.augSetSize) + "_" + num2str(seed_redicExp) + "_results.mat";

    end

    rng(seed_redicExp);
    seeds_addPts = randi(1.0e+6, [numTrials, 1]);

    mrsaValuesArray = zeros(numTrials, numEms);
    rmseArray = zeros(numTrials, 1);
    reArray = zeros(numTrials, 1);
    elapsedTimes = zeros(numTrials, 1);

    fprintf('Running REDIC experiment on %s dataset with (lambda, tau) = (%d, %d) ... \n', ...
        dataName, redicOpts.augSetSize, redicOpts.numEehtRuns);

    for i = 1:numTrials

        fprintf('REDIC run: %d / %d \n', i, numTrials);
        redicOpts.seed_addPts = seeds_addPts(i);
        startTime = tic;
        [estEmSigs, obtainedSetSize] = redic(A, numEms, redicOpts, eehtOpts);
        elapsedTime = toc(startTime);

        [mrsaValues, correspondance] = matchRefs(refSigs, estEmSigs);
        estEmSigs_arranged = estEmSigs(:, correspondance);

        mrsaValuesArray(i, :) = mrsaValues;
        elapsedTimes(i) = elapsedTime;

    end

    elapsedTimeExp = toc(startTimeExp);
    fprintf('Elapsed time for experiment: %1.2f s \n', elapsedTimeExp);

    save(outFileName, 'mrsaValuesArray', 'obtainedSetSize', 'elapsedTimes', ...
        'elapsedTimeExp', 'seeds_addPts', 'inData', 'redicOpts');

end
