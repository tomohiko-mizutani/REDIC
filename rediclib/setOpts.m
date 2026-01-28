function [opts] = setOpts(opts, defaultOpts)

    optFields = fieldnames(defaultOpts);

    for i = 1:numel(optFields)

        if ~isfield(opts, optFields{i}) || isempty(opts.(optFields{i}))
            opts.(optFields{i}) = defaultOpts.(optFields{i});
        end

    end

end
