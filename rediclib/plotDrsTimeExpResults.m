function [] = plotDrsTimeExpResults(inData, augSetSize)

    augSetSize = 0;

    switch inData

        case 'dataset1'
            datasetName = "Dataset 1";

        case 'dataset2'
            datasetName = "Dataset 2";

        case 'dataset3'
            datasetName = "Dataset 3";

    end

    numIntervals = 16;

    fileName = "../scripts/results/drsExp_" + inData + "_50_" + augSetSize + "_73_results.mat";
    load(fileName, 'elapsedTimes', 'nuValues');

    figure;
    bar(nuValues, elapsedTimes);
    hold off;

    xticks(nuValues);
    yl = ylim;
    ylim([yl(1), yl(2) * 1.05]);

    title('DRS Elapsed Time for ' + datasetName + ' ($\lambda$ = ' + string(augSetSize) + ')', 'Interpreter', 'latex');
    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('Elapsed Time (s)', 'Interpreter', 'latex');

    ax = gca;
    ax.TickLabelInterpreter = 'latex';

    set(gca, 'FontSize', 23);
    box on;

end
