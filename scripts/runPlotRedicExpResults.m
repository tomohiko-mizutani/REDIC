clear; 
inData = ["jasper", "samson", "urban"];

for i = 1:length(inData)

    plotRedicExpResults(inData(i));
    if i < length(inData);
        fprintf('\n');
    end

end