function [defaultOpts] = getDefaultEehtOpts(n)

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
