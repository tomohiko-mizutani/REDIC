function [defaultOpts] = getDefaultRedicOpts()

    defaultOpts.numPartitions = 30;
    defaultOpts.numEehtRuns = 1;
    defaultOpts.augSetSize = 0;

    defaultOpts.seed_kmeans = 37;
    defaultOpts.seed_addPts = 9848034;

    defaultOpts.epsilon = 1.0e-8;

    defaultOpts.displayFlag = 0; 

end
