function [] = plotEehtResults(A, gtIndices, outIndices, elapsedTime)

    fprintf('=== Results === \n');
    fprintf('[EEHT-A] \n');

    recoveryRate.eehtA = compRecoveryRate(gtIndices, outIndices.eehtA);
    fprintf('Recovery rate  : %1.2f \n', recoveryRate.eehtA);

    mrsaValues.eehtA = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtA), 'mrsa');
    fprintf('MRSA score     : %1.2f\n', mean(mrsaValues.eehtA));

    sadValues.eehtA = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtA), 'sad');
    fprintf('SAD score      : %1.2f \n\n', mean(sadValues.eehtA));

    fprintf('[EEHT-B] \n');

    if isempty(outIndices.eehtB)
        fprintf('EEHT-B could not find r indices. \n\n');
    else
        recoveryRate.eehtB = compRecoveryRate(gtIndices, outIndices.eehtB);
        fprintf('Recovery rate  : %1.2f \n', recoveryRate.eehtB);

        mrsaValues.eehtB = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtB), 'mrsa');
        fprintf('MRSA score     : %1.2f \n', mean(mrsaValues.eehtB));

        sadValues.eehtB = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtB), 'sad');
        fprintf('SAD score      : %1.2f \n\n', mean(sadValues.eehtB));
    end

    fprintf('[EEHT-C] \n');

    if isempty(outIndices.eehtC)
        fprintf('EEHT-C could not find r indices. \n\n');
    else
        recoveryRate.eehtC = compRecoveryRate(gtIndices, outIndices.eehtC);
        fprintf('Recovery rate  : %1.2f \n', recoveryRate.eehtC);

        mrsaValues.eehtC = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtC), 'mrsa');
        fprintf('MRSA score     : %1.2f \n', mean(mrsaValues.eehtC));

        sadValues.eehtC = compMetricValues(A(:, gtIndices), A(:, outIndices.eehtC), 'sad');
        fprintf('SAD score      : %1.2f \n\n', mean(sadValues.eehtC));
    end

    fprintf('Elapsed time   : %.2f s \n', elapsedTime);

end

function [recoveryRate] = compRecoveryRate(gtIndices, estIndices)

    recoveryRate = length(intersect(gtIndices, estIndices)) / size(gtIndices, 2);

end
