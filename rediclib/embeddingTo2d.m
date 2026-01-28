function [A_2d, refSigs_2d] = embeddingTo2d(A, refSigs, numEms)

    [d, n] = size(A);

    A_expanded = [A, refSigs];
    [U, S, V] = svds(A_expanded, numEms, 'largest');

    normal_vec = U' * ones(d, 1);
    normal_vec_scaled = normal_vec * (1 / norm(normal_vec, 2));
    P = [null(normal_vec_scaled'), normal_vec_scaled]';

    F = P * getIntersectionsWithHyperplane(S * V', normal_vec_scaled);

    A_2d = F(1:2, 1:n);
    refSigs_2d = F(1:2, n + 1:end);

end

function [A_scaled] = getIntersectionsWithHyperplane(A, normal_vec)

    scale_vec = normal_vec' * A;
    A_scaled = A ./ scale_vec;

end
