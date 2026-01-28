function [H] = compAbundanceMat(A, W)

    r = size(W, 2);
    n = size(A, 2);

    A = A ./ vecnorm(A, 1);
    W = W ./ vecnorm(W, 1);

    P = W' * W;
    H = zeros(r, n);

    for i = 1:n

        qVec = -1 * W' * A(:, i);
        Aineq = [];
        bineq = [];

        Aeq = ones(1, r);
        beq = 1;

        lb = zeros(r, 1);
        ub = inf * ones(r, 1);

        options = optimset('Display', 'off');
        sol = quadprog(P, qVec, Aineq, bineq, Aeq, beq, lb, ub, [], options);

        H(:, i) = sol;

    end

end
