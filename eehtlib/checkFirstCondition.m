function [L, y_mat, v, optValP, outIndices, pointList, numSolvedLPs] = checkFirstCondition(A, factorRank, L, opts)

    if opts.displayFlag == 1
        fprintf('[Checking first conditions ...]\n');
    end

    n = size(A, 2);
    iter = 1;

    while true

        if opts.displayFlag == 1
            fprintf('Iteration = %d \n', iter);
            fprintf('|L| = %d \n', size(L, 2));
        end

        [x_mat, y_mat, v, optValP] = solveRhtByCplexMex(A(:, L), factorRank);

        d_vec = diag(x_mat);

        allData = 1:n;
        I = allData(d_vec > 0);

        p_vec = d_vec(I, 1);
        B = A(:, L);
        C = B(:, I);

        L_comp = setdiff(1:n, L);

        % Step 2-2
        if isempty(L_comp) == 1

            pointList = zeros(n, 1);
            pointList(L, 1) = d_vec;

            [~, sortedArrayIndices] = sort(d_vec, 'descend');
            J = sortedArrayIndices(1:factorRank)';
            outIndices = sort(L(J));

            numSolvedLPs = iter;

            if opts.displayFlag == 1
                fprintf('\n');
            end

            break;
        end

        testIndices = findTestIndicesByCplexMex(A, C, p_vec, L_comp, optValP, opts);

        if opts.displayFlag == 1
            fprintf('|testIndices| = %d \n\n', size(testIndices, 2));
        end

        if isempty(testIndices) == 1

            pointList = zeros(n, 1);
            pointList(L, 1) = d_vec;

            [~, sortedArrayIndices] = sort(d_vec, 'descend');
            J = sortedArrayIndices(1:factorRank)';
            outIndices = sort(L(J));

            numSolvedLPs = iter;

            break;

        else

            L = [L, testIndices];
            iter = iter + 1;

        end

    end

end
