function [] = train(paramsFile)
fullTrainStart = now;

netCNN = googlenet;
inputSize = netCNN.Layers(1).InputSize(1:2);
[fileNames, constParams, variableParams, allParams] = train.prepareParams(paramsFile);


numTests = size(variableParams, 2);
numRepeats = constParams.numRepeats;

[results] = train.initResultsStruct(numTests);
[globalInfos] = train.initLstmInfosStruct(numTests, numRepeats);

for i = constParams.startTestIdx:numTests
    testStart = now;

    [labelsMap, ~, trainListing, validationListing] = common.prepareFiles(i, allParams);
    [trainSequences, trainLabels, validationSequences, validationlabels] = train.prepareSequences(netCNN, labelsMap, trainListing, validationListing, allParams, i);
    [layers, optionsCells] = train.prepareLSTMParameters(trainSequences, trainLabels, validationSequences, validationlabels, allParams);
    classes = categories(trainLabels);
    
    
    [infos] = train.initLstmInfosStruct(1, numRepeats);
    classifyResults = zeros(numRepeats, 1);
    repeatTimeResults = zeros(numRepeats);

    for j = 1:numRepeats
        fprintf("Test %d of %d (repeat %d of %d)...\n", i, numTests, j, numRepeats);
        repeatStart = now;
  
        [netLSTM, info] = trainNetwork(trainSequences, trainLabels, layers(:, i), optionsCells{i});
        [net] = train.assembleNetsIfRequired(netCNN, netLSTM, constParams);
        
        [classifyResult] = train.testClassifyIfRequired(allParams, labelsMap, net, classes, inputSize, i, j);
            
        repeatStop = now;
        [repeatTime, repeatTimetring] = common.calculateTimeResult(repeatStart, repeatStop);
        repeatTimeResults(j) = repeatTime;
        
        infos(j) = info;
        classifyResults(j) = classifyResult;
        
        saveNetworksIfRequired(info);
        
        [~, elapsedTimeString, timeStampString] = common.calculateTimeResult(fullTrainStart, repeatStop);
        fprintf("Repeat time(HH:MM:SS): %s, elapsed time: %s, time stamp: %s\n", repeatTimetring, elapsedTimeString, timeStampString);
    end
    
    numIterationsPerEpoch = optionsCells{i}.ValidationFrequency;
    [repeatResultsTab] = train.calculateResults(infos, classifyResults, repeatTimeResults, numIterationsPerEpoch);
    
    testStop = now;
    [fullTestTime, fullTestTimeString] = common.calculateTimeResult(testStart, testStop);
    
    [results] = train.prepareTestResults(allParams, results, repeatResultsTab, i, fullTestTime, fullTestTimeString);
    globalInfos(i, :) = infos;
    train.saveResultsIfRequired(allParams, results, globalInfos)
    
    [~, elapsedTimeString, timeStampString] = common.calculateTimeResult(fullTrainStart, repeatStop);
    fprintf("Finished test %d of %d, test time(HH:MM:SS): %s, elapsed time: %s, time stamp: %s\n", i, numTests, fullTestTimeString, elapsedTimeString, timeStampString);
end

fullTrainStop = now;
[~, fullTrainTimeString, timeStampString] = common.calculateTimeResult(fullTrainStart, fullTrainStop);
fprintf("--Training finished with time(HH:MM:SS): %s, time stamp: %s--\n", fullTrainTimeString, timeStampString);

function [] = saveNetworksIfRequired(info)
    
    expectedResultAchieved = info.FinalValidationLoss <= constParams.minExpectedValidLoss || info.FinalValidationAccuracy >= constParams.maxExpectedValidAccuracy;
    if (expectedResultAchieved)
        filePrefix = sprintf("test-%d_repeat-%d_", i, j);
    else
        filePrefix = "";
    end
    
    if constParams.saveLSTMNetwork || expectedResultAchieved
        file = fullfile(fileNames.saveNetsFolder, filePrefix + fileNames.lstmMatFileName);
        save(file, "netLSTM", "info", "classes", "-v7.3");
        fprintf("- LSTM network saved\n");
    end
    if constParams.saveLSTMFullData || expectedResultAchieved
        file = fullfile(fileNames.saveNetsFolder, filePrefix + fileNames.lstmFullMatFileName);
        save(file, "-v7.3");
        fprintf("- LSTM full data saved\n");
    end
    if constParams.assembleNetworks && (constParams.saveFinalNetwork || expectedResultAchieved)
        file = fullfile(fileNames.saveNetsFolder, filePrefix + fileNames.finalNetMatFileName);
        save(file, "net", "classes", "info", "-v7.3");
        fprintf("- Final assembled network saved\n");
    end
end
end