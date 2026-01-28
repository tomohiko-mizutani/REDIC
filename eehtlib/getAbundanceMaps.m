function [abundanceMaps] = getAbundanceMaps(A, refSigs, estSigs)

    abundanceMaps.refSigs = compAbundanceMat(A, refSigs);
    abundanceMaps.eehtA = compAbundanceMat(A, estSigs.eehtA);
    abundanceMaps.eehtB = compAbundanceMat(A, estSigs.eehtB);
    abundanceMaps.eehtC = compAbundanceMat(A, estSigs.eehtC);

end
