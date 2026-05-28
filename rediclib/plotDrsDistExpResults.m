function [] = plotDrsDistExpResults(inData)

    switch inData

        case 'dataset1'
            augSetSizes = [0, 50, 100, 150, 200, 250];
            datasetName = "Dataset 1";

        case 'dataset2'
            augSetSizes = [0, 50, 100, 150, 200, 250];
            datasetName = "Dataset 2";

        case 'dataset3_part1'
            augSetSizes = [0, 500, 1000, 1500, 2000, 2500];
            inData = extractBefore(inData, '_');
            datasetName = "Dataset 3";

        case 'dataset3_part2'
            augSetSizes = [0, 2500, 5000, 7500, 10000, 12500];
            inData = extractBefore(inData, '_');
            datasetName = "Dataset 3";

    end

    numIntervals = 16;

    aveL1Dists = zeros(length(augSetSizes), numIntervals);
    aveMrsaDists = zeros(length(augSetSizes), numIntervals);

    for i = 1:length(augSetSizes)

        fileName = "../scripts/results/drsExp_" + inData + "_50_" + augSetSizes(i) + "_73_results.mat";
        load(fileName, 'dists', 'nuValues');

        for j = 1:numIntervals
            aveL1Dists(i, j) = mean(mean(dists(j).l1, 2));
            aveMrsaDists(i, j) = mean(mean(dists(j).mrsa, 2));
        end

    end

    colors = orderedcolors("gem");
    colors([1, 2], :) = colors([2, 1], :);

    markers = {'o', 'x', 's', 'd', '^', 'v', '+'};

    % Plot L1 distance results
    figure;

    for i = length(augSetSizes):-1:1

        graphs(i) = plot(nuValues, aveL1Dists(i, :), ...
            '-', ...
            'Marker', markers{i}, ...
            'Color', colors(i, :), ...
            'MarkerSize', 12, ...
            'LineWidth', 2);

        hold on;

    end

    hold off;

    xlim([0 1.5]);

    switch inData
        case 'jasper'
            ylim([0 0.35]);

        case 'samson'
            ylim([0 0.8]);

        case 'urban'
            ylim([0 0.12]);
    end

    title('DRS on ' + datasetName, 'Interpreter', 'latex');
    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('$L_1$ distance', 'Interpreter', 'latex');

    ax = gca;
    ax.TickLabelInterpreter = 'latex';

    legend(graphs, '$\lambda =$ ' + string(augSetSizes), 'Location', 'northwest', 'Interpreter', 'latex');
    lgd = legend;
    lgd.NumColumns = 2;
    uistack(lgd, 'bottom');

    set(gca, 'FontSize', 23);
    box on; grid on;

    % Plot MRSA distance results
    figure;

    for i = length(augSetSizes):-1:1

        graphs(i) = plot(nuValues, aveMrsaDists(i, :), ...
            '-', ...
            'Marker', markers{i}, ...
            'Color', colors(i, :), ...
            'MarkerSize', 12, ...
            'LineWidth', 2);
        hold on;

    end

    hold off;

    xlim([0 1.5]);
    ylim([0 13]);

    title('DRS on ' + datasetName, 'Interpreter', 'latex');
    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('MRSA distance', 'Interpreter', 'latex');

    ax = gca;
    ax.TickLabelInterpreter = 'latex';

    legend(graphs, '$\lambda =$ ' + string(augSetSizes), 'Location', 'northwest', 'Interpreter', 'latex');
    lgd = legend;
    lgd.NumColumns = 2;
    uistack(lgd, 'bottom');

    hold off;
    set(gca, 'FontSize', 23);
    box on; grid on;

end
