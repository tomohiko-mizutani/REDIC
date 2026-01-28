function [chosenIndices] = postProcMaxPoint(A, factorRank, pointList)

    n = size(A, 2);
    dataCluster = struct('elements', [], 'points', [], 'diam', []);

    for j = 1:factorRank

        minDiam = inf;
        elements = [];

        for i = 1:n

            a_vec = A(:, i);
            [distances, sortedArrayIndices] = sort(sum(abs(A - repmat(a_vec, 1, n))));

            totalPoints = cumsum(pointList(sortedArrayIndices));

            I = 1:n;
            I(totalPoints <= factorRank / (factorRank + 1)) = [];

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

    chosenIndices = findIndicesByMaxPoint(dataCluster, factorRank);

end

function [chosenIndices] = findIndicesByMaxPoint(dataCluster, factorRank)

    chosenIndices = [];

    for j = 1:factorRank

        elements = dataCluster(j).elements;
        points = dataCluster(j).points;

        if isempty(elements) == 0

            [~, indexOfMaxPoint] = max(points);
            chosenIndices = [chosenIndices, elements(indexOfMaxPoint)];

        end

    end

    if length(chosenIndices) ~= factorRank
        chosenIndices = [];
    end

end
