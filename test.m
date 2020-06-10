clear
% 
dataFolder = 'D:\Dane do pracy dyplomowej\sigexp\DATA';
paramsFile = fullfile(dataFolder, 'params.csv');
% load(lstmFull);

% tableListing = struct2table(listing);
% writetable(tableListing, 'tableListing.xlsx');
% writetable(tableListing, 'tableListing.csv');

% results = struct('folder', fullListing(1).folder, 'name', fullListing(1).name);
% listing(end+1) = struct('folder', fullListing(imgIdx).folder, 'name', fullListing(imgIdx).name);

netCNN = googlenet;
inputSize = netCNN.Layers(1).InputSize(1:2);

[fileNames, constParams, variableParams, allParams] = train.prepareParams(paramsFile);
[labelsMap] = common.prepareLabels(fileNames.labelsCsvFile);
load(fileNames.finalNetMatFile, 'net', 'classes', 'info');
%load(fileNames.classifyResultsMatFile);

train.testClassifyIfRequired(allParams, labelsMap, net, classes, inputSize, 'test1_');