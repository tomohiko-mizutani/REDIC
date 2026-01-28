function [testIndices] = findTestIndicesByCplexMex(A, C, p_vec, L_comp, optValP, opts)

    d = size(A, 1);

    numX = size(C, 2);
    numY = d;

    f = -1 * [zeros(numX, 1); ones(numY, 1)];

    Aineq = sparse([C, -eye(d); -C, -eye(d)]);

    lb = [zeros(numX, 1); -inf(numY, 1)];
    ub = [p_vec; inf(numY, 1)];

    testIndices = [];
    numData = size(L_comp, 2);
    method = 0;

    for i = 1:numData

        index = L_comp(i);
        a_vec = A(:, index);
        bineq = [a_vec; -a_vec];

        [~, objVal, ~, ~] = cplexlp_mex(f, Aineq, bineq, lb, ub, method);
        objVal = -objVal;

        if objVal - optValP > opts.zeroTol
            testIndices = [testIndices, index];
        end

    end

    clearvars f Aineq bineq lb ub

end
