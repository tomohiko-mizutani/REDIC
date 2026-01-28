function [A, gtIndices] = genNormalData(d, n, factorRank, delta, seed)

    rng(seed, 'twister');

    W = abs(rand(d, factorRank));
    W = W ./ vecnorm(W, 1);

    alpha = rand(factorRank, 1);
    H_bar = dirRnd(alpha, n - factorRank);
    H = [eye(factorRank, factorRank), H_bar];

    R = randn(d, n);
    N = (delta / norm(R, 1)) * R;

    V = W * H;
    A = V + N;

    perm = randperm(n);
    A = A(:, perm);

    [~, sortedArrayIndices] = sort(perm);
    gtIndices = sortedArrayIndices(1:factorRank);

end

function [P] = dirRnd(alpha, n)

    r = size(alpha, 1);
    P = zeros(r, n);

    for i = 1:r
        P(i, :) = gamrnd(alpha(i), 1, 1, n);
    end

    sumLst = sum(P);
    P = P ./ repmat(sumLst, r, 1);

end

