inData = 'jasper';
numTrials = 50;
seed_drsExp = 73;
augSetSizes = [0, 50, 100, 150, 200, 250];

opts.displayFlag = 0;

for i = 1:length(augSetSizes)
    drsExp(inData, numTrials, augSetSizes(i), seed_drsExp, opts);
end

% -----------------------------------------------------------
inData = 'samson';
numTrials = 50;
seed_drsExp = 73;
augSetSizes = [0, 50, 100, 150, 200, 250];

opts.displayFlag = 0;

for i = 1:length(augSetSizes)
    drsExp(inData, numTrials, augSetSizes(i), seed_drsExp, opts);
end

% -----------------------------------------------------------
inData = 'urban';
numTrials = 50;
seed_drsExp = 73;
augSetSizes = [0, 500, 1000, 1500, 2000, 2500, 5000, 7500, 10000, 12500];

opts.displayFlag = 0;

for i = 1:length(augSetSizes)
    drsExp(inData, numTrials, augSetSizes(i), seed_drsExp, opts);
end