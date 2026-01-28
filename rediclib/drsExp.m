function [] = drsExp(inData, numTrials, augSetSize, seed_drsExp, opts)

    startTimeExp = tic;

    defaultOpts = getDefaultDrsOpts();
    opts = setOpts(opts, defaultOpts);

    switch inData

        case 'jasper'

            load('../data/synthetic_data/jasper.mat', 'W', 'H', 'N');

            dataName = "Dataset 1";
            refSigs = W;
            numEms = size(W, 2);
            outFileName = "drsExp_dataset1_" ...
                + num2str(numTrials) + "_" + num2str(augSetSize) + "_" + num2str(seed_drsExp) + "_results.mat";

        case 'samson'

            load('../data/synthetic_data/samson.mat', 'W', 'H', 'N');

            dataName = "Dataset 2";
            refSigs = W;
            numEms = size(W, 2);
            outFileName = "drsExp_dataset2_" ...
                + num2str(numTrials) + "_" + num2str(augSetSize) + "_" + num2str(seed_drsExp) + "_results.mat";

        case 'urban'

            load('../data/synthetic_data/urban.mat', 'W', 'H', 'N');

            dataName = "Dataset 3";
            refSigs = W;
            numEms = size(W, 2);
            outFileName = "drsExp_dataset3_" ...
                + num2str(numTrials) + "_" + num2str(augSetSize) + "_" + num2str(seed_drsExp) + "_results.mat";

    end

    nuValues = 0:0.1:1.5;
    numIntervals = length(nuValues);

    rng(seed_drsExp);
    seeds_addPts = randi(1.0e+6, [numIntervals, 1]);

    elapsedTimes = zeros(numIntervals, 1);
    obtainedSetSizes = zeros(numIntervals, 1);

    fprintf('Running DRS experiment on %s dataset with augSetSize = %d ... \n', ...
        dataName, augSetSize);

    for i = 1:numIntervals

        fprintf('DRS run: %d / %d \n', i, numIntervals);

        nu = nuValues(i);
        A = W * H + (nu / norm(N, 1)) * N;

        startTimeForDrs = tic;

        [~, S, V] = svds(A, numEms, 'largest');
        A_dimReduced = S * V';
        boundaryIndices = drs(A_dimReduced, opts);
        numBoundaryPoints = length(boundaryIndices);

        obtainedSetSizes(i) = numBoundaryPoints;
        elapsedTimes(i) = toc(startTimeForDrs);
        dists(i).l1 = zeros(numTrials, numEms);
        dists(i).mrsa = zeros(numTrials, numEms);

        seed_addPts = seeds_addPts(i);
        allColumnIndices = 1:size(A, 2);

        for j = 1:numTrials

            rng(seed_addPts + j - 1);

            if numBoundaryPoints < augSetSize
                numElementsToAdd = augSetSize - numBoundaryPoints;
                drsOutIndices = [boundaryIndices, datasample(setdiff(allColumnIndices, boundaryIndices), ...
                                     numElementsToAdd, 'Replace', false)];
            else
                drsOutIndices = boundaryIndices;
            end

            distanceType = 'l1';
            [l1Dists, ~] = getMinDistances(A(:, drsOutIndices), refSigs, distanceType);
            dists(i).l1(j, :) = l1Dists;

            distanceType = 'mrsa';
            [mrsaDists, ~] = getMinDistances(A(:, drsOutIndices), refSigs, distanceType);
            dists(i).mrsa(j, :) = mrsaDists;

        end

    end

    elapsedTimeExp = toc(startTimeExp);
    fprintf('Elapsed time for experiment: %1.2f s\n', elapsedTimeExp);

    save(outFileName, 'dists', 'obtainedSetSizes', 'elapsedTimes', ...
        'nuValues', 'elapsedTimeExp', 'seeds_addPts', 'inData', 'opts');

end
