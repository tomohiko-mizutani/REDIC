function [boundaryIndices] = nnlsDr(A, epsilon)

    tolerance = 1.0e-14;

    uniqColIndices = removeSimilarColumns(A, tolerance);
    A = A(:, uniqColIndices);

    n = size(A, 2);
    I = 1:n;
    lsqnonnegOpts = optimset('Display', 'off');

    for i = 1:n

        C = A(:, setdiff(I, i));
        a_vec = A(:, i);

        [~, funcValue, ~] = lsqnonneg(C, a_vec, lsqnonnegOpts);

        if sqrt(funcValue) < epsilon

            indexToRemove = find(I == i);
            I(indexToRemove) = [];

        end

    end

    boundaryIndices = uniqColIndices(I);

end

function [uniqColIndices] = removeSimilarColumns(A, tol)

    n = size(A, 2);
    keep = true(1, n);

    A = A ./ vecnorm(A, 2);

    for i = 1:n

        if ~keep(i)
            continue;
        end

        sims = A(:, i)' * A;
        dists = 1 - sims;
        closeIndices = find(dists < tol);

        closeIndices(closeIndices <= i) = [];
        keep(closeIndices) = false;

    end

    uniqColIndices = find(keep);

end


function [A_scaled] = columnScaling(A, interceptTerm)

    center = mean(A ./ vecnorm(A, 2), 2);
    scalingFactors = interceptTerm ./ (center' * A);
    scalingFactors(scalingFactors < 0) = interceptTerm;

    A_scaled = A .* scalingFactors;

end
