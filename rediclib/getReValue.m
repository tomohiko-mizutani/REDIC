function [reValue] = getReValue(A, chosenColumns)

    n = size(A, 2);
    lsqnonnegOpts = optimset('Display', 'off');

    for i = 1:n

        a_vec = A(:, i);
        H(:, i) = lsqnonneg(chosenColumns, a_vec, lsqnonnegOpts);

    end

    reValue = norm(A - chosenColumns * H, 'fro') / sqrt(numel(A));

end
