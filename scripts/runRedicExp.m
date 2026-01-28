inData = 'jasper';
numTrials = 50;
seed_redicExp = 73;
augSetSizes = [50, 100, 150, 200, 250];

redicOpts.numEehtRuns = 1;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end

redicOpts.numEehtRuns = 5;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end

% -----------------------------------------------------------
inData = 'samson';
numTrials = 50;
seed_redicExp = 73;
augSetSizes = [50, 100, 150, 200, 250];

redicOpts.numEehtRuns = 1;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end

redicOpts.numEehtRuns = 5;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end

% -----------------------------------------------------------
inData = 'urban';
numTrials = 50;
seed_redicExp = 73;
augSetSizes = [500, 1000, 1500, 2000, 2500, 5000, 7500, 10000, 12500];

redicOpts.numEehtRuns = 1;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end

redicOpts.numEehtRuns = 5;

for i = 1:length(augSetSizes)
    redicOpts.augSetSize = augSetSizes(i);
    redicExp(inData, numTrials, seed_redicExp, redicOpts);
end
