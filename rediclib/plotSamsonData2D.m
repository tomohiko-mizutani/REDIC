function [obtainedSetSize, numCols] = plotSamsonData2D()

    opts = struct();
    defaultOpts = getDefaultDrsOpts();
    opts = setOpts(opts, defaultOpts);

    load('../data/real_data/samson.mat', 'A', 'refIndices', 'endmembers');
    refSigs = A(:, refIndices);
    numEms = length(refIndices);
    numCols = size(A, 2);


    [~, S, V] = svds(A, numEms, 'largest');
    A_dimReduced = S * V';
    boundaryIndices = drs(A_dimReduced, opts);
    obtainedSetSize = length(boundaryIndices);

    A_sizeReduced = A_dimReduced(:, boundaryIndices);
    [A_2d, refSigs_2d] = embeddingTo2d(A, refSigs, numEms);

    figure(1);
    plotPixels = plot(A_2d(1, :), A_2d(2, :), '.', 'Color', 'k', 'MarkerSize', 10);
    hold on
    plotEms = plot(refSigs_2d(1, :), refSigs_2d(2, :), 'x', 'Color', 'r', 'MarkerSize', 12, 'LineWidth', 3);
    hold off

    title('2D visualization of the Samson dataset (before DRS)');
    xlim([-0.8 1.6]);
    ylim([-0.6 1.0]);

    ax = gca;
    ax.XTick = [];
    ax.YTick = [];

    legend([plotPixels, plotEms], ...
        'Pixels of the Samson dataset', 'Reference endmember signatures', 'Location', 'northeast');

    set(gca, 'FontSize', 16);

    figure(2);
    plotPixels = plot(A_2d(1, boundaryIndices), A_2d(2, boundaryIndices), '.', 'Color', 'k', 'MarkerSize', 10);
    hold on
    plotEms = plot(refSigs_2d(1, :), refSigs_2d(2, :), 'x', 'Color', 'r', 'MarkerSize', 12, 'LineWidth', 3);
    hold off

    title('2D visualization of the Samson dataset (after DRS)');
    xlim([-0.8 1.6]);
    ylim([-0.6 1.0]);

    ax = gca;
    ax.XTick = [];
    ax.YTick = [];

    legend([plotPixels, plotEms], ...
        'Pixels of the Samson dataset', 'Reference endmember signatures', 'Location', 'northeast');

    set(gca, 'FontSize', 16);

end
