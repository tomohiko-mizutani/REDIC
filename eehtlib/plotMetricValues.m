function [] = plotMetricValues(preprocOpt)

    load('../data/real_data/urban.mat', 'endmembers');

    inFileName = "./results/urbanUnmixing_preproc" + num2str(preprocOpt) + "_results.mat";
    load(inFileName, 'metricValues', 'elapsedTime');

    numEms = length(endmembers);

    fprintf('=== Results of EEHT methods with preprocessing-%d on Urban dataset === \n\n', preprocOpt);
    fprintf('[%s values] \n', upper(metricValues.type));
    fprintf('Endmember     EEHT-A   EEHT-B   EEHT-C \n');
    fprintf('--------------------------------------- \n');

    for i = 1:numEms
        endmember = endmembers(i);
        fprintf('%-7s    ', upper(extractBefore(endmember, 2)) + extractAfter(endmember, 1));
        fprintf('%8.1f ', metricValues.eehtA(i));
        fprintf('%8.1f ', metricValues.eehtB(i));
        fprintf('%8.1f \n', metricValues.eehtC(i));
    end

    fprintf('--------------------------------------- \n');
    fprintf('Mean       ');
    fprintf('%8.1f ', mean(metricValues.eehtA));
    fprintf('%8.1f ', mean(metricValues.eehtB));
    fprintf('%8.1f \n\n', mean(metricValues.eehtC));

    fprintf('[Elapsed time]  \n');
    fprintf('%.2f s \n', elapsedTime);


end
