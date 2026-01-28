function [mrsa_value] = computeMrsa(sig1, sig2)

    sig1_meanRemoved = sig1 - mean(sig1) * ones(length(sig1), 1);
    sig2_meanRemoved = sig2 - mean(sig2) * ones(length(sig2), 1);

    numerator = sig1_meanRemoved' * sig2_meanRemoved;
    denominator = norm(sig1_meanRemoved, 2) * norm(sig2_meanRemoved, 2);

    mrsa_value = (100 / pi) * acos(min(numerator / denominator, 1));

end
