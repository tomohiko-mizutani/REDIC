function [metricValues, correspondance] = compMetricValues(refSigs, estSigs, metricType)

    [d, r] = size(estSigs);

    metricValues_2dArray = zeros(r, r);

    switch metricType
        case 'mrsa'

            for j = 1:r

                estSig = estSigs(:, j);
                estSig_meanRemoved = estSig - mean(estSig) * ones(d, 1);

                for i = 1:r

                    refSig = refSigs(:, i);
                    refSig_meanRemoved = refSig - mean(refSig) * ones(d, 1);

                    numerator = estSig_meanRemoved' * refSig_meanRemoved;
                    denominator = norm(estSig_meanRemoved, 2) * norm(refSig_meanRemoved, 2);

                    metricValues_2dArray(j, i) = (100 / pi) * acos(min(numerator / denominator, 1));

                end

            end

        case 'sad'

            for j = 1:r

                estSig = estSigs(:, j);

                for i = 1:r

                    refSig = refSigs(:, i);

                    numerator = estSig' * refSig;
                    denominator = norm(estSig, 2) * norm(refSig, 2);

                    metricValues_2dArray(j, i) = (100 / pi) * acos(min(numerator / denominator, 1));

                end

            end

    end

    solution = solveAssignmentProb(metricValues_2dArray);
    [correspondance, ~] = find(solution);

    metricValues_2dArray = metricValues_2dArray(correspondance, :);
    metricValues = diag(metricValues_2dArray);

end

function [solution] = solveAssignmentProb(distances_2dArray)

    n = size(distances_2dArray, 1);
    f = reshape(distances_2dArray', n ^ 2, 1);

    Aupper = repmat(eye(n, n), 1, n);
    Alower = kron(eye(n, n), ones(1, n));

    Aeq = [Aupper; Alower];
    beq = ones(2 * n, 1);
    lb = zeros(n ^ 2, 1);

    linprogOptions = optimoptions('linprog', 'Display', 'none');
    [solution_vec, objVal] = linprog(f, [], [], Aeq, beq, lb, [], linprogOptions);

    solution = reshape(solution_vec, n, n)';

    for i = 1:n

        for j = 1:n

            if abs(solution(i, j) - 1) < 1.0e-5
                solution(i, j) = 1;
            else
                solution(i, j) = 0;
            end

        end

    end

end

