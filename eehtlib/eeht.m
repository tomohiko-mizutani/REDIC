function [outIndices, outRce, opts] = eeht(A, factorRank, opts)

    n = size(A, 2);

    if nargin < 3 || isempty(opts)

        defaultOpts = getDefaultOpts(n);
        opts = defaultOpts;

    else

        defaultOpts = getDefaultOpts(n);
        opts = setOpts(opts, defaultOpts);

        if opts.zeta * factorRank + opts.eta > size(A, 2)
            error('Please adjust zeta and eta to ensure that zeta * factorRank + eta <= the number of columns in A');
        end

    end

    if opts.displayFlag == 1
        fprintf('####  Input matrix #### \n');
        fprintf('Number of rows:     %d \n', size(A, 1));
        fprintf('Number of columns:  %d \n', size(A, 2));
        fprintf('Factorization rank: %d \n\n', factorRank);
    end

    A_dimReduced = reduceDimensionality(A, factorRank);
    outRce = rce(A_dimReduced, factorRank, opts);
    outIndices.eehtA = outRce.indices;
    outIndices.eehtB = postProcMaxPoint(A_dimReduced, factorRank, outRce.pointList);
    outIndices.eehtC = postProcCentroid(A_dimReduced, factorRank, outRce.pointList);

end

function [defaultOpts] = getDefaultOpts(n)

    if n <= 300
        defaultOpts.zeta = 0;
        defaultOpts.eta = 'all';
    elseif n <= 50000
        defaultOpts.zeta = 10;
        defaultOpts.eta = 100;
    else
        defaultOpts.zeta = 50;
        defaultOpts.eta = 300;
    end

    defaultOpts.zeroTol = 1.0e-6;
    defaultOpts.seedInitSet = 3887;
    defaultOpts.displayFlag = 0;

end

function [opts] = setOpts(opts, defaultOpts)

    optFields = fieldnames(defaultOpts);

    for i = 1:numel(optFields)

        if ~isfield(opts, optFields{i}) || isempty(opts.(optFields{i}))
            opts.(optFields{i}) = defaultOpts.(optFields{i});
        end

    end

end
