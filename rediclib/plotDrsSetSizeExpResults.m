function [] = plotDrsSetSizeExpResults(inData)

    augSetSize = 0;

    switch inData

        case 'dataset1'
            datasetName = "Dataset 1";

        case 'dataset2'
            datasetName = "Dataset 2";

        case 'dataset3';
            datasetName = "Dataset 3";

    end

    numIntervals = 16;

    fileName = "../scripts/results/drsExp_" + inData + "_50_" + augSetSize + "_73_results.mat";
    load(fileName, 'obtainedSetSizes', 'nuValues');

    figure;
    bar(nuValues, obtainedSetSizes);
    hold off;

    xticks(nuValues);
    yl = ylim;
    ylim([yl(1), yl(2) * 1.05]);

    title('Number of Elements in $\mathcal{K}$ Obtained by DRS for ' + datasetName, 'Interpreter', 'latex');
    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('$|\mathcal{K}|$', 'Interpreter', 'latex');

    ax = gca;
    ax.TickLabelInterpreter = 'latex';

    set(gca, 'FontSize', 23);
    box on;


end
