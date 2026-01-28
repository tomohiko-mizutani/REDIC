function [] = plotLmmExpResults(datasetOpt)

    switch datasetOpt
        case 1
            load('./results/lmmExp_dataset1_results.mat', 'algo', 'nuValues');
        case 2
            load('./results/lmmExp_dataset2_results.mat', 'algo', 'nuValues');
    end


    figure;
    tiledlayout(1, 2);

    switch datasetOpt
        case 1
            sgtitle('Dataset 1 generated from Jasper Ridge HSI', 'FontSize', 20, 'FontName', 'Arial');
        case 2
            sgtitle('Dataset 2 generated from Samson HSI', 'FontSize', 20, 'FontName', 'Arial');
    end

    % Plot MRSA scores
    nexttile;

    plot_EEHT_A = plot(nuValues, algo(1).mrsaScores, ...
        'd-', ...
        'Color', '#77AC30', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold on

    plot_EEHT_B = plot(nuValues, algo(2).mrsaScores, ...
        's-', ...
        'Color', '#0072BD', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold on

    plot_EEHT_C = plot(nuValues, algo(3).mrsaScores, ...
        'o-', ...
        'Color', '#D95319', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold off

    xlim([0 1]);
    ylim([0 40]);

    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('MRSA score');

    legend([plot_EEHT_A, plot_EEHT_B, plot_EEHT_C], ...
        'EEHT-A', 'EEHT-B', 'EEHT-C', 'Location', 'northeast');

    set(gca, 'FontSize', 20, 'FontName', 'Arial');

    % Plot SAD scores
    nexttile;

    plot_EEHT_A = plot(nuValues, algo(1).sadScores, ...
        'd-', ...
        'Color', '#77AC30', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold on

    plot_EEHT_B = plot(nuValues, algo(2).sadScores, ...
        's-', ...
        'Color', '#0072BD', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold on

    plot_EEHT_C = plot(nuValues, algo(3).sadScores, ...
        'o-', ...
        'Color', '#D95319', ...
        'MarkerSize', 12, ...
        'LineWidth', 2);
    hold off

    xlim([0 1]);
    ylim([0 40]);

    xlabel('$\nu$', 'Interpreter', 'latex');
    ylabel('SAD score');

    legend([plot_EEHT_A, plot_EEHT_B, plot_EEHT_C], ...
        'EEHT-A', 'EEHT-B', 'EEHT-C', 'Location', 'northeast');

    set(gca, 'FontSize', 20, 'FontName', 'Arial');

end
