function [outRce] = rce(A, factorRank, opts)

    L = findInitSet(A, factorRank, opts);

    totalSolvedLPs = 0;
    iter = 1;

    if opts.displayFlag == 1
        fprintf('######  Algorithm started ###### \n');
    end

    while true

        if opts.displayFlag == 1
            fprintf('\n--- Iteration = %d --- \n', iter);
        end

        [L, y_mat, v, optValP, outIndices, pointList, numSolvedLPs] = checkFirstCondition(A, factorRank, L, opts);
        totalSolvedLPs = totalSolvedLPs + numSolvedLPs;

        [L, terminationFlag] = checkSecondCondition(A, L, y_mat, v, opts);

        if terminationFlag == 1

            optVal = optValP;
            maxColumnSize = size(L, 2);

            if opts.displayFlag == 1
                fprintf('\n###### Algorithm finished ###### \n\n');
            end

            break;

        else
            iter = iter + 1;
        end

    end

    outRce.indices = outIndices;
    outRce.pointList = pointList;
    outRce.optVal = optVal;
    outRce.maxColumnSize = maxColumnSize;
    outRce.totalSolvedLPs = totalSolvedLPs;

end

