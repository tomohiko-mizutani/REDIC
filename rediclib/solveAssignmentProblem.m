function [solution] = solveAssignmentProblem(distances_2dArray)

    zeroTol = 1.0e-5;

    n = size(distances_2dArray, 1);
    c_vec = reshape(distances_2dArray', n ^ 2, 1);

    ub_Aeq = repmat(eye(n, n), 1, n);
    lb_Aeq = kron(eye(n, n), ones(1, n));

    Aeq = [ub_Aeq; lb_Aeq];
    beq = ones(2 * n, 1);
    lb = zeros(n ^ 2, 1);

    options = optimoptions('linprog', 'Display', 'none');
    [solution_vec, ~, ~, ~] = linprog(c_vec, [], [], Aeq, beq, lb, [], options);

    solution = reshape(solution_vec, n, n)';

    for i = 1:n

        for j = 1:n
            val = solution(i, j);

            if val > 1 - zeroTol && val < 1 + zeroTol
                solution(i, j) = 1;
            else
                solution(i, j) = 0;
            end

        end

    end

end
