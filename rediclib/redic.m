function [estEmSigs, numBoundaryPoints] = redic(A, numEms, redicOpts, eehtOpts)

    if redicOpts.displayFlag == 1
        displayRedicOpts(redicOpts);
        fprintf('Algorithm started... \n');
    end

    [~, S, V] = svds(A, numEms, 'largest');
    A_dimReduced = S * V';

    boundaryIndices = drs(A_dimReduced, redicOpts);
    numBoundaryPoints = length(boundaryIndices);

    estEmIndices = zeros(redicOpts.numEehtRuns, numEms);
    allColumnIndices = 1:size(A, 2);

    for i = 1:redicOpts.numEehtRuns

        if redicOpts.displayFlag == 1
            fprintf('EEHT run: %d / %d \n', i, redicOpts.numEehtRuns);
        end

        success = false;
        attempt = 0;

        while ~success

            attempt = attempt + 1;
            rng(redicOpts.seed_addPts + i - 1 + attempt);

            if numBoundaryPoints < redicOpts.augSetSize
                numElementsToAdd = redicOpts.augSetSize - numBoundaryPoints;
                drsOutIndices = [boundaryIndices, datasample(setdiff(allColumnIndices, boundaryIndices), ...
                                     numElementsToAdd, 'Replace', false)];
            else
                drsOutIndices = boundaryIndices;
            end

            A_sizeReduced = A_dimReduced(:, drsOutIndices);
            numColsReduced = size(A_sizeReduced, 2);

            defaultEehtOpts = getDefaultEehtOpts(numColsReduced);
            localEehtOpts = setOpts(eehtOpts, defaultEehtOpts);

            outRce = rce(A_sizeReduced, numEms, localEehtOpts);
            eehtOutIndices = postProcCentroid(A_sizeReduced, numEms, outRce.pointList);

            if ~isempty(eehtOutIndices)
                success = true;
                estEmIndices(i, :) = drsOutIndices(eehtOutIndices);
            else
                fprintf('Retry %d: EEHT could not obtain %d endmembers. \n', attempt, numEms);
            end

            if attempt > 30
                error('EEHT could not obtain a valid estimate after 30 attempts. Algorithm terminated.');
            end

        end

    end

    if redicOpts.numEehtRuns == 1
        estEmSigs = A(:, estEmIndices(1, :));
    else
        estEmSigs = getEstEmSigs(A, estEmIndices);
    end

    if redicOpts.displayFlag == 1
        fprintf('Algorithm terminated \n\n');
    end

end

function [estEmSigs] = getEstEmSigs(A, estEmIndices);

    d = size(A, 1);
    [numEehtRuns, numEms] = size(estEmIndices);
    sigsArray = zeros(d, numEms, numEehtRuns);

    for i = 1:numEehtRuns
        sigs = A(:, estEmIndices(i, :));

        if i == 1
            sigsArray(:, :, i) = sigs;
        else
            aveSigs = mean(sigsArray(:, :, 1:i - 1), 3);
            [~, correspondance] = matchRefs(aveSigs, sigs);
            sigs_arranged = sigs(:, correspondance);
            sigsArray(:, :, i) = sigs_arranged;
        end

    end

    estEmSigs = mean(sigsArray(:, :, 1:numEehtRuns), 3);

end

function [] = displayRedicOpts(redicOpts)

    fprintf('------------------------------------------------ \n');
    fprintf('[REDIC options] \n');
    fprintf('Number of additional points (lambda) : %d \n', redicOpts.augSetSize);
    fprintf('Number of EEHT runs (tau)            : %d \n', redicOpts.numEehtRuns);
    fprintf('Number of partitions                 : %d \n', redicOpts.numPartitions);
    fprintf('K-means seed                         : %d \n', redicOpts.seed_kmeans);
    fprintf('Additional points seed               : %d \n', redicOpts.seed_addPts);
    fprintf('Epsilon                              : %.2e \n', redicOpts.epsilon);
    fprintf('Display flag                         : %d \n', redicOpts.displayFlag);
    fprintf('------------------------------------------------ \n\n');

end
