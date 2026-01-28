function [] = plotRedicExpResults(inData)

    numEehtRuns = [1, 5];

    switch inData

        case 'jasper'
            augSetSizes = [50, 100, 150, 200, 250];
            dataName = "Jasper Ridge";

        case 'samson'
            augSetSizes = [50, 100, 150, 200, 250];
            dataName = "Samson";

        case 'urban'
            augSetSizes = [500, 1000, 1500, 2000, 2500, 5000, 7500, 10000, 12500];
            dataName = "Urban";

    end

    mrsaScores = zeros(length(augSetSizes), length(numEehtRuns));
    stdMrsaScores = zeros(length(augSetSizes), length(numEehtRuns));
    meanElapsedTimes = zeros(length(augSetSizes), length(numEehtRuns));
    stdElapsedTimes = zeros(length(augSetSizes), length(numEehtRuns));

    for j = 1:length(augSetSizes)

        for k = 1:length(numEehtRuns)

            fileName = "../scripts/results/redicExp_" + inData + "_50_" + numEehtRuns(k) + "_" + augSetSizes(j) + "_73_results.mat";
            load(fileName, 'mrsaValuesArray', 'elapsedTimes');

            mrsaScores(j, k) = mean(mean(mrsaValuesArray, 2));
            stdMrsaScores(j, k) = std(mean(mrsaValuesArray, 2));
            meanElapsedTimes(j, k) = mean(elapsedTimes);
            stdElapsedTimes(j, k) = std(elapsedTimes);

        end

    end

    fprintf('=== Results for %s dataset === \n', dataName);
    fprintf(' (lambda, tau)  MRSA score (std)   Elapsed time (std) \n');

    for j = 1:length(augSetSizes)

        for k = 1:length(numEehtRuns)

            fprintf('    (%5d, %d)  ', augSetSizes(j), numEehtRuns(k));
            fprintf('    %5.2f (%4.2f)   ', mrsaScores(j, k), stdMrsaScores(j, k));
            fprintf('    %6.1f (%5.1f)  \n', meanElapsedTimes(j, k), stdElapsedTimes(j, k));

        end

    end
   

end
