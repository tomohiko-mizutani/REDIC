function [] = plotOpts(opts)

    fprintf('=== EEHT options === \n');
    fprintf('zeta          : %d \n', opts.zeta);

    if isnumeric(opts.eta)
        fprintf('eta           : %d \n', opts.eta);
    else
        fprintf('eta           : %s \n', opts.eta);
    end

    fprintf('zeroTol       : %e \n', opts.zeroTol);
    fprintf('seedInitSet   : %d \n', opts.seedInitSet);
    fprintf('displayFlag   : %d \n\n', opts.displayFlag);

end
