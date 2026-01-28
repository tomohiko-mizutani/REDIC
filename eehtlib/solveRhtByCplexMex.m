function [xMat, yMat, v, optValP] = solveRhtByCplexMex(A, factorRank)

    [d, n] = size(A);
    numVars = n ^ 2 + d * n + 2 * n + 1;

    % Objective function
    f = [reshape(A, d * n, 1); zeros(n, 1); factorRank; ones(n, 1); zeros(n ^ 2, 1)];

    % 1st constraints
    A1 = sparse([kron(speye(n), A)]);

    I = speye(n);
    b = reshape(I, 1, n ^ 2);

    blocks = cell(n, 1);

    for i = 1:n
        unit_vec = zeros(n, 1);
        unit_vec(i) = 1;
        blocks{i} = unit_vec';
    end

    A4 = sparse(blkdiag(blocks{:}));

    I = speye(n);
    A5 = [];

    for i = 1:n
        J = sparse(n, n);
        J(:, i) = ones(n, 1);
        A5 = sparse([A5; kron(speye(n) - J, I(i, :))]);
    end

    C1 = [A1', sparse(n ^ 2, n), b', A4', A5'];
    rhv1 = zeros(n ^ 2, 1);

    % 2nd constraints
    A2 = [speye(d * n), -speye(d * n)];

    A3 = sparse([kron(speye(n), ones(1, d)), kron(speye(n), ones(1, d))]);

    C2 = [A2', A3', sparse(2 * d * n, n ^ 2 + n + 1)];
    rhv2 = zeros(2 * d * n, 1);

    % 3rd constraints
    C3 = [sparse(1, d * n), -ones(1, n), sparse(1, n ^ 2 + n + 1)];
    rhv3 = 1;

    Aineq = [C1; C2; C3];
    bineq = [rhv1; rhv2; rhv3];

    lb = -inf(numVars, 1);
    ub = [inf(d * n, 1); zeros(n, 1); inf; zeros(n ^ 2 + n, 1)];

    method = 0;
    [solution, objVal, lambda, exitflag] = cplexlp_mex(f, Aineq, bineq, lb, ub, method);

    optValP = objVal;

    x = lambda.ineqlin(1:n ^ 2, 1);
    xMat = reshape(x, [n, n]);

    y = solution(1:d * n, 1);
    yMat = reshape(y, [d, n]);

    v = solution(d * n + n + 1, 1);

    clearvars f Aineq bineq lb ub
    clearvars A1 A2 A3 A4 A5 C1 C2 C3 rhv1 rhv2 rhv3

end
