function [boundaryIndices] = drs(A, opts)

    rng(opts.seed_kmeans);

    n = size(A, 2);
    A_transposed = A';

    labels = kmeans(A_transposed, opts.numPartitions, ...
        'Display', 'off', ...
        'start', 'plus', ...
        'emptyaction', 'singleton', ...
        'MaxIter', 1000);

    chosenIndices = [];
    allColumnIndices = 1:n;

    for i = 1:opts.numPartitions

        A_partitioned = A(:, labels == i);
        partitionedIndices = allColumnIndices(labels == i);

        epsilon = opts.epsilon;
        drsOutIndices = nnlsDr(A_partitioned, epsilon);

        chosenIndices = [chosenIndices, partitionedIndices(drsOutIndices)];

    end

    epsilon = opts.epsilon;
    drsOutIndices = nnlsDr(A(:, chosenIndices), epsilon);

    boundaryIndices = chosenIndices(drsOutIndices);

end
