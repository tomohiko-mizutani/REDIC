function [L, terminationFlag] = checkSecondCondition(A, L, y_mat, v, opts)

    if opts.displayFlag == 1
        fprintf('[Checking second conditions ...]\n');
    end

    n = size(A, 2);

    L_comp = setdiff(1:n, L);
    testIndices = checkRedCost(A, y_mat, v, L_comp, opts);

    if opts.displayFlag == 1
        fprintf('|testIndices| = %d \n\n', size(testIndices, 2));
    end

    if isempty(testIndices) == 1
        terminationFlag = 1;
    else
        L = [L, testIndices];
        terminationFlag = 0;
    end

end
