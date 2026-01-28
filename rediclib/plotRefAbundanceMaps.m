function [] = plotRefAbundanceMaps(inData)

    switch inData

        case 'jasper'
            load('../scripts/results/jasperRefAbundanceMaps.mat', 'abundanceMaps', 'endmembers');
            numRow = 100;
            numCol = 100;

        case 'samson'
            load('../scripts/results/samsonRefAbundanceMaps.mat', 'abundanceMaps', 'endmembers');
            numRow = 95;
            numCol = 95;

        case 'urban'
            load('../scripts/results/urbanRefAbundanceMaps.mat', 'abundanceMaps', 'endmembers');
            numRow = 307;
            numCol = 307;
    end

    numEms = length(endmembers);

    figure('Color', 'w');

    t = tiledlayout(1, numEms, 'TileSpacing', 'compact', 'Padding', 'compact');
    colormap(gray);

    for i = 1:numEms

        ax = nexttile;
        image(reshape(abundanceMaps(i, :), numRow, numCol), 'CDataMapping', 'scaled');
        axis(ax, 'image');
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'off');

        endmember = endmembers(i);
        title(ax, upper(extractBefore(endmember, 2)) + extractAfter(endmember, 1), ...
            'FontSize', 14, 'FontName', 'Arial');

    end

end
