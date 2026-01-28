function [testIndices] = checkRedCost(A, y_mat, v, L_comp, opts)

    testIndices = [];
    numData = size(L_comp, 2);

    for i = 1:numData

        index = L_comp(i);
        p_vec = y_mat' * A(:, index);
        val = sum(p_vec(p_vec >= 0)) + v;

        if val > opts.zeroTol
            testIndices = [testIndices, index];
        end

    end

end
