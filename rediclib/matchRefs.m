function [mrsaValues, correspondance] = matchRefs(sigs1, sigs2)

    [d, r] = size(sigs1);

    mrsa_2dArray = zeros(r, r);

    for j = 1:r

        sig1 = sigs1(:, j);

        for i = 1:r

            sig2 = sigs2(:, i);
            mrsa_2dArray(i, j) = computeMrsa(sig1, sig2);

        end

    end

    solution = solveAssignmentProblem(mrsa_2dArray);
    [correspondance, ~] = find(solution);

    mrsa_2dArray = mrsa_2dArray(correspondance, :);
    mrsaValues = diag(mrsa_2dArray);

end
