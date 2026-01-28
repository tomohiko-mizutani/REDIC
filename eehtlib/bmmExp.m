function [] = bmmExp(datasetOpt, opts)

    numTrials = 20;
    nu_prime = 0.2;
    seed_bmmExp = 74;

    switch datasetOpt
        case 3
            load('../data/synthetic_data/jasper.mat', 'W', 'H', 'N');
            numEms = size(W, 2);

        case 4
            load('../data/synthetic_data/samson.mat', 'W', 'H', 'N');
            numEms = size(W, 2);
    end

    fprintf('[BMM Experiment | Dataset %d] \n', datasetOpt);

    algo = struct('name', [], 'mrsaScores', [], 'sadScores', []);

    minNu = 0.2;
    maxNu = 0.8;
    p = 4;

    nuValues = linspace(minNu, maxNu, p);

    for i = 1:p

        nu = nuValues(i);

        for j = 1:numTrials

            fprintf('(%d / %d | %d / %d) \n', i, p, j, numTrials);

            seed_intMat = seed_bmmExp + j;
            [W_hat, H_hat] = genIntMat(W, H, numEms, seed_intMat);

            M = W_hat * H_hat;
            A = W * H + (nu_prime / norm(M, 1)) * M + (nu / norm(N, 1)) * N;

            [outIndices, ~, opts] = eeht(A, numEms, opts);

            algo(1).name = 'EEHT-A';
            mrsaValues = compMetricValues(W, A(:, outIndices.eehtA), 'mrsa');
            algo(1).mrsaScores(i, j) = mean(mrsaValues);
            sadValues = compMetricValues(W, A(:, outIndices.eehtA), 'sad');
            algo(1).sadScores(i, j) = mean(sadValues);

            algo(2).name = 'EEHT-B';
            mrsaValues = compMetricValues(W, A(:, outIndices.eehtB), 'mrsa');
            algo(2).mrsaScores(i, j) = mean(mrsaValues);
            sadValues = compMetricValues(W, A(:, outIndices.eehtB), 'sad');
            algo(2).sadScores(i, j) = mean(sadValues);

            algo(3).name = 'EEHT-C';
            mrsaValues = compMetricValues(W, A(:, outIndices.eehtC), 'mrsa');
            algo(3).mrsaScores(i, j) = mean(mrsaValues);
            sadValues = compMetricValues(W, A(:, outIndices.eehtC), 'sad');
            algo(3).sadScores(i, j) = mean(sadValues);

        end

    end

    outFileName = "bmmExp_dataset" + num2str(datasetOpt) + "_results.mat";
    save(outFileName, 'algo', 'nuValues', 'opts');

end


function [W_hat, H_hat] = genIntMat(W, H, r, seed)

    rng(seed);

    d = size(W, 1);
    n = size(H, 2);

    num_virtualData = r * (r - 1) / 2;
    W_hat = zeros(d, num_virtualData);
    counter = 1;

    for j = 1:r - 1

        for i = j + 1:r

            W_hat(:, counter) = W(:, j) .* W(:, i);
            counter = counter + 1;

        end

    end

    mixingRates = rand(num_virtualData, n);
    H_hat = zeros(num_virtualData, n);

    for k = 1:n

        counter = 1;

        for j = 1:r - 1

            for i = j + 1:r

                H_hat(counter, k) = mixingRates(counter, k) * H(j, k) * H(i, k);
                counter = counter + 1;

            end

        end

    end

end
