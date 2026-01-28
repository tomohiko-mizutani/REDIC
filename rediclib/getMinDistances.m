function [minDistances, closestIndices] = getMinDistances(chosenColumns, refSigs, distanceType)

    numChosenColumns = size(chosenColumns, 2);
    numEms = size(refSigs, 2);

    minDistances = zeros(1, numEms);
    closestIndices = zeros(1, numEms);

    for i = 1:numEms

        refSig = refSigs(:, i);

        for j = 1:numChosenColumns

            switch distanceType
                case 'l1'
                    d_vec = refSig - chosenColumns(:, j);
                    distances(j) = norm(d_vec, 1);
                case 'mrsa'
                    distances(j) = computeMrsa(refSig, chosenColumns(:, j));
            end

        end

        [min_distance, index] = min(distances);
        minDistances(1, i) = min_distance;
        closestIndices(1, i) = index;

    end

end
