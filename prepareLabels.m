function [labelsMap] = prepareLabels(filename)

[~, ~, labels] = xlsread(filename);
[labelsLength, ~] = size(labels);

keySet = cell(1, labelsLength);
valueSet = cell(1, labelsLength);

for i = 1:labelsLength
    keyValueCell = strsplit(labels{i}, ',');
    keySet{i} = keyValueCell{1};
    valueSet{i} = keyValueCell{2};
end

labelsMap = containers.Map(keySet,valueSet);

end