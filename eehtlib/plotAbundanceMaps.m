function [] = plotAbundanceMaps(preprocOpt)

    load('../data/real_data/urban.mat', 'endmembers');

    inFileName = "./results/urbanUnmixing_preproc" + num2str(preprocOpt) + "_results.mat";
    load(inFileName, 'abundanceMaps');

    numEms = length(endmembers);
    numRow = 307;
    numCol = 307;


    figure('Color', 'w');

    t = tiledlayout(4, numEms + 1, 'TileSpacing', 'compact', 'Padding', 'compact');
    colormap(gray);

    % Row 1
    ax = nexttile;
    axis off;
    text(0.95, 0.5, 'Reference', 'HorizontalAlignment', 'right', ...
        'FontSize', 14, 'FontName', 'Arial');

    for i = 1:numEms

        ax = nexttile;
        image(reshape(abundanceMaps.refSigs(i, :), numRow, numCol), 'CDataMapping', 'scaled');
        axis(ax, 'image');
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'off');

        endmember = endmembers(i);
        title(ax, upper(extractBefore(endmember, 2)) + extractAfter(endmember, 1), ...
            'FontSize', 14, 'FontName', 'Arial');

    end

    % Row 2
    ax = nexttile;
    axis off;
    text(0.95, 0.5, 'EEHT-A', 'HorizontalAlignment', 'right', ...
        'FontSize', 14, 'FontName', 'Arial');

    for i = 1:numEms
        ax = nexttile;
        image(reshape(abundanceMaps.eehtA(i, :), numRow, numCol), 'CDataMapping', 'scaled');
        axis(ax, 'image');
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'off');
    end

    % Row 3
    ax = nexttile;
    axis off;
    text(0.95, 0.5, 'EEHT-B', 'HorizontalAlignment', 'right', ...
        'FontSize', 14, 'FontName', 'Arial');

    for i = 1:numEms
        ax = nexttile;
        image(reshape(abundanceMaps.eehtB(i, :), numRow, numCol), 'CDataMapping', 'scaled');
        axis(ax, 'image');
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'off');
    end

    % Row 4
    ax = nexttile;
    axis off;
    text(0.95, 0.5, 'EEHT-C', 'HorizontalAlignment', 'right', ...
        'FontSize', 14, 'FontName', 'Arial');

    for i = 1:numEms
        ax = nexttile;
        image(reshape(abundanceMaps.eehtC(i, :), numRow, numCol), ...
            'CDataMapping', 'scaled');
        axis(ax, 'image');
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'off');
    end

end
