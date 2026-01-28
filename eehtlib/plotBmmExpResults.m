function [] = plotBmmExpResults(datasetOpt)

    switch datasetOpt
        case 3
            load('./results/bmmExp_dataset3_results.mat', 'algo', 'nuValues');
        case 4
            load('./results/bmmExp_dataset4_results.mat', 'algo', 'nuValues');
    end

    numNuValues = length(nuValues);

    fprintf('BMM experiment results (Dataset %d) \n', datasetOpt);
    fprintf('Noise levels (nu) ');

    for i = 1:numNuValues
        fprintf('%4.1f ', nuValues(i));
    end

    fprintf('\n');
    fprintf('[MRSA scores] \n');

    fprintf('EEHT-A            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(1).mrsaScores(i, :)));
    end

    fprintf('\n');

    fprintf('EEHT-B            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(2).mrsaScores(i, :)));
    end

    fprintf('\n');

    fprintf('EEHT-C            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(3).mrsaScores(i, :)));
    end

    fprintf('\n\n');
    fprintf('[SAD scores] \n');

    fprintf('EEHT-A            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(1).sadScores(i, :)));
    end

    fprintf('\n');

    fprintf('EEHT-B            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(2).sadScores(i, :)));
    end

    fprintf('\n');

    fprintf('EEHT-C            ');

    for i = 1:numNuValues
        fprintf('%4.1f ', mean(algo(3).sadScores(i, :)));
    end

    fprintf('\n\n');

end
