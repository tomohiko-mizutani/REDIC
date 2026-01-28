function [chosenIndices] = postProcCentroid(A, factorRank, pointList)

    n = size(A, 2);
    dataCluster = struct('elements', [], 'points', [], 'diam', []);

    for j = 1:factorRank

        minDiam = inf;
        elements = [];

        for i = 1:n

            a_vec = A(:, i);
            [distances, sortedArrayIndices] = sort(sum(abs(A - repmat(a_vec, 1, n))));

            cumSumArray = cumsum(pointList(sortedArrayIndices));

            I = 1:n;
            I(cumSumArray <= factorRank / (factorRank + 1)) = [];

            if isempty(I) == 0

                minIndex = min(I);
                diam = distances(1, minIndex);

                if diam < minDiam

                    elements = sortedArrayIndices(1:minIndex);
                    minDiam = diam;

                end

            end

        end

        dataCluster(j).elements = elements;
        dataCluster(j).points = pointList(elements);
        dataCluster(j).diam = minDiam;

        pointList(elements) = 0;

    end

    chosenIndices = findIndicesByCentroid(A, dataCluster, factorRank);

end

function [chosenIndices] = findIndicesByCentroid(A, dataCluster, factorRank)

    d = size(A, 1);
    chosenIndices = [];

    for j = 1:factorRank

        elements = dataCluster(j).elements;

        if isempty(elements) == 0

            centroid = mean(A(:, elements), 2);
            centroid_meanRemoved = normalizeColumnsByL2(centroid - repmat(mean(centroid), d, 1));

            B = A(:, elements);
            B_meanRemoved = normalizeColumnsByL2(B - repmat(mean(B), d, 1));

            mrsaValues = acos(min(centroid_meanRemoved' * B_meanRemoved, 1));
            [~, indexOfMinMrsa] = min(mrsaValues);

            chosenIndices = [chosenIndices, elements(indexOfMinMrsa)];

        end

    end

    if length(chosenIndices) ~= factorRank
        chosenIndices = [];
    end

end

function [A_scaled] = normalizeColumnsByL2(A)

    A_scaled = A ./ vecnorm(A, 2);

end
