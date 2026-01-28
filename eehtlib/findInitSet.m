function [L] = findInitSet(A, factorRank, opts)

    n = size(A, 2);

    if opts.zeta == 0 && strcmp(opts.eta, 'all')
        L = 1:n;
    else
        spaOutIndice = spa(A, factorRank);
        L = [];

        for i = 1:factorRank

            a_vec = A(:, spaOutIndice(i));
            D = A - repmat(a_vec, 1, n);

            distLst = sum(D .^ 2);
            [~, J] = sort(distLst, 'ascend');

            nbrIndices = J(1:opts.zeta);

            L = [L, nbrIndices];

        end

        L = unique(L);

        rng(opts.seedInitSet);
        L_comp = setdiff(1:n, L);
        L = [L, randsample(L_comp, opts.eta)];

    end

end
