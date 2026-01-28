function [chosenIndices] = spa(A, factorRank)

    residuals = sum(A .^ 2);

    d = size(A, 1);
    U = zeros(d, factorRank);
    chosenIndices = zeros(1, factorRank);
    initResiduals = residuals;

    for i = 1:factorRank

        [maxVal, index] = max(residuals);
        index = checkTie(residuals, initResiduals, maxVal, index);

        chosenIndices(i) = index;
        u_vec = A(:, index);

        for j = 1:i - 1

            val = U(:, j)' * u_vec;
            u_vec = u_vec - val * U(:, j);

        end

        u_vec = u_vec / norm(u_vec, 2);

        U(:, i) = u_vec;
        residuals = residuals - (u_vec' * A) .^ 2;

    end

end

function [index] = checkTie(residuals, initResiduals, maxVal, index)

    indices = find((maxVal - residuals) / maxVal <= 1.0e-6);

    if length(indices) > 1

        [~, subIndex] = max(initResiduals(indices));
        index = indices(subIndex);

    end

end
