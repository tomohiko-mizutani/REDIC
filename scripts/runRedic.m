clear;

inData = 'jasper'; % 'jasper', 'samson', 'urban'

% redicOpts.numPartitions = 10;
% redicOpts.numEehtRuns = 5;
% redicOpts.augSetSize = 100;
% redicOpts.displayFlag = 0; 

if ~exist('redicOpts', 'var')
    redicOpts = struct();
end

defaultRedicOpts = getDefaultRedicOpts();
redicOpts = setOpts(redicOpts, defaultRedicOpts);

if ~exist('eehtOpts', 'var')
    eehtOpts = struct();
end

switch inData

    case 'jasper'
        load('../data/real_data/jasper.mat', 'A', 'refIndices', 'endmembers');

        dataName = "Jasper Ridge";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);

    case 'samson'
        load('../data/real_data/samson.mat', 'A', 'refIndices', 'endmembers');

        dataName = "Samson";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);

    case 'urban'
        load('../data/real_data/urban.mat', 'A', 'refIndices', 'endmembers');
        load('../data/real_data/colsToRemove_40_10.mat', 'colsToRemove');

        dataName = "Urban";
        refSigs = A(:, refIndices);
        numEms = length(refIndices);
        A(:, colsToRemove) = [];

end

startTime = tic;
[estEmSig, ~] = redic(A, numEms, redicOpts, eehtOpts);
elapsedTime = toc(startTime);

mrsaValues = matchRefs(refSigs, estEmSig);

fprintf('=== Results for %s dataset === \n', dataName);
fprintf('[MRSA values] \n');

for i = 1:numEms
    endmember = endmembers(i);
    fprintf('%-8s : %5.2f\n', upper(extractBefore(endmember, 2)) + extractAfter(endmember, 1), mrsaValues(i));
end

fprintf('----------------- \n');
fprintf('Mean     : %5.2f \n\n', mean(mrsaValues));
fprintf('[Elapsed time] \n');
fprintf('%.2f s \n', elapsedTime);
