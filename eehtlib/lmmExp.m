function [] = lmmExp(datasetOpt, opts)

    switch datasetOpt
        case 1
            load('../data/synthetic_data/jasper.mat', 'W', 'H', 'N');
            numEms = size(W, 2);

        case 2
            load('../data/synthetic_data/samson.mat', 'W', 'H', 'N');
            numEms = size(W, 2);
    end

    fprintf('[LMM Experiment | Dataset %d] \n', datasetOpt);

    algo = struct('name', [], 'indices', [], 'mrsaScores', [], 'sadScores', []);

    minNu = 0;
    maxNu = 1;
    p = 20;
    nuValues = linspace(minNu, maxNu, p);

    optValues = zeros(p, 1);
    pointLists = zeros(p, size(H, 2));

    for i = 1:p

        fprintf('%d / %d \n', i, p);

        nu = nuValues(i);

        A = W * H + (nu / norm(N, 1)) * N;

        [outIndices, outRce, opts] = eeht(A, numEms, opts);

        optValues(i) = outRce.optVal;
        pointLists(i, :) = outRce.pointList';

        algo(1).name = 'EEHT-A';
        algo(1).indices(i, :) = outIndices.eehtA;
        mrsaValues = compMetricValues(W, A(:, outIndices.eehtA), 'mrsa');
        algo(1).mrsaScores(i) = mean(mrsaValues);
        sadValues = compMetricValues(W, A(:, outIndices.eehtA), 'sad');
        algo(1).sadScores(i) = mean(sadValues);

        algo(2).name = 'EEHT-B';
        algo(2).indices(i, :) = outIndices.eehtB;
        mrsaValues = compMetricValues(W, A(:, outIndices.eehtB), 'mrsa');
        algo(2).mrsaScores(i) = mean(mrsaValues);
        sadValues = compMetricValues(W, A(:, outIndices.eehtB), 'sad');
        algo(2).sadScores(i) = mean(sadValues);

        algo(3).name = 'EEHT-C';
        algo(3).indices(i, :) = outIndices.eehtC;
        mrsaValues = compMetricValues(W, A(:, outIndices.eehtC), 'mrsa');
        algo(3).mrsaScores(i) = mean(mrsaValues);
        sadValues = compMetricValues(W, A(:, outIndices.eehtC), 'sad');
        algo(3).sadScores(i) = mean(sadValues);

    end

    outFileName = "lmmExp_dataset" + num2str(datasetOpt) + "_results.mat";
    save(outFileName, 'algo', 'nuValues', 'optValues', 'pointLists', 'opts');

end
