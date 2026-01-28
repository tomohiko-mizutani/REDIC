function [metricValues, estSigs] = evaluateMetricValues(A, refSigs, outIndices, metricType)

    metricValues.type = metricType;
    [metricValues.eehtA, correspondence.eehtA] = compMetricValues(refSigs, A(:, outIndices.eehtA), metricType);
    [metricValues.eehtB, correspondence.eehtB] = compMetricValues(refSigs, A(:, outIndices.eehtB), metricType);
    [metricValues.eehtC, correspondence.eehtC] = compMetricValues(refSigs, A(:, outIndices.eehtC), metricType);

    estSigs.eehtA = A(:, outIndices.eehtA(correspondence.eehtA));
    estSigs.eehtB = A(:, outIndices.eehtB(correspondence.eehtB));
    estSigs.eehtC = A(:, outIndices.eehtC(correspondence.eehtC));

end