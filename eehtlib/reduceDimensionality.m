function [A_dimReduced] = reduceDimensionality(A, factorRank)

    [~, S, V] = svds(A, factorRank, 'largest');
    A_dimReduced = S * V';

end
