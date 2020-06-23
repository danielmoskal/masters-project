clear
% 
dataFolder = 'D:\Dane do pracy dyplomowej\sigexp\DATA\test';
paramsFile = fullfile(dataFolder, 'params.csv');
testFile = fullfile(dataFolder, 'sigexp_LSTM_full.mat');
labelsCsvFile = fullfile(dataFolder, 'labels.csv');
testGesturesFile = fullfile(dataFolder, 'test_gesture.mat');
testSequence = fullfile(dataFolder, 'sequences\person-A,B_sigexp_train_sequences.mat');

%load(testFile);

%train(paramsFile);

% tableListing = struct2table(listing);
% writetable(tableListing, 'tableListing.xlsx');
% writetable(tableListing, 'tableListing.csv');

% results = struct('folder', fullListing(1).folder, 'name', fullListing(1).name);
% listing(end+1) = struct('folder', fullListing(imgIdx).folder, 'name', fullListing(imgIdx).name);

% netCNN = googlenet;
% inputSize = netCNN.Layers(1).InputSize(1:2);
% % 
% [fileNames, constParams, variableParams, allParams] = train.prepareParams(paramsFile);
% [labelsMap] = common.prepareLabels(labelsCsvFile);
% load(fileNames.finalNetMatFile, 'net', 'classes', 'info');
% %load(fileNames.classifyResultsMatFile);
% 
% train.testClassifyIfRequired(allParams, labelsMap, net, classes, inputSize, 'test1_');

[fileNames, constParams, variableParams, allParams] = train.prepareParams(paramsFile);
% labelsMap = common.prepareLabels(fileNames.labelsCsvFile);
% [listing] = common.prepareListing(fileNames.dataFileListing, labelsMap, ["PersonA", "PersonB"]);

% [net] = train.assembleNetsIfRequired(netCNN, netLSTM, constParams);

% [labels, gestures, gesturesListing] = testGestures(labelsMap, listing, inputSize, testGesturesFile);

% [sequencesTrain, labelsTrain, sequencesValidation, labelsValidation] = train.prepareTrainingData(sequences, labels, constParams);
% 
% 
% trainData = struct("trainSequences", sequencesTrain, "trainLabels", cellstr(string(labelsTrain)));
% testData = struct("testSequences", sequencesValidation, "testLabels", cellstr(string(labelsValidation)));