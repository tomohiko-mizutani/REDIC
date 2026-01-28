clear; close all;

[obtainedSetSize, numCols] = plotSamsonData2D();
fprintf('=== 2D visualization of the Samson dataset === \n\n');
fprintf('Number of pixels of the Samson dataset (before DRS)     : %d\n', numCols);
fprintf('Number of pixels of the Samson dataset (after DRS)      : %d\n', obtainedSetSize);