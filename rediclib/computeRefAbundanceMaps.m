function [abundanceMaps] = computeRefAbundanceMaps(inData)

    switch inData

        case 'jasper'
            load('../data/real_data/jasper.mat', 'A', 'refIndices', 'endmembers');
            outFileName = 'jasperRefAbundanceMaps.mat';

        case 'samson'
            load('../data/real_data/samson.mat', 'A', 'refIndices', 'endmembers');
            outFileName = 'samsonRefAbundanceMaps.mat';

        case 'urban'
            load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers');
            outFileName = 'urbanRefAbundanceMaps.mat';

    end

    refSigs = A(:, refIndices);
    abundanceMaps = computeAbundanceMat(A, refSigs);
    save(outFileName, 'abundanceMaps', 'endmembers');

end
