function [results] = prepareTestResults(params, results, repeatResultsTab, index, fullTestTime, fullTestTimeString)

    constParams = params.const;
    variableParams = params.variable;
    
    results(index).ID = index;
    results(index).plot = constParams.plot;
    results(index).learnRateSchedule = constParams.learnRateSchedule;
    results(index).onlyCorrectValidationSequence = constParams.onlyCorrectValidationSequence;
    results(index).maxAllowedSequenceLength = constParams.maxAllowedSequenceLength;
    results(index).numRepeats = constParams.numRepeats;
    
    results(index).bilstmOutputMode = variableParams(index).bilstmOutputMode;
    results(index).initialLearnRate = variableParams(index).initialLearnRate;
    results(index).learnRateDropPeriod = variableParams(index).learnRateDropPeriod;
    results(index).learnRateDropFactor = variableParams(index).learnRateDropFactor;
    results(index).gradientThreshold = variableParams(index).gradientThreshold;
    results(index).shuffle = variableParams(index).shuffle;
    results(index).vPatience = variableParams(index).validationPatience;
    results(index).maxEpochs = variableParams(index).maxEpochs;
    results(index).miniBatchSize = variableParams(index).miniBatchSize;
    results(index).solver = variableParams(index).solver;
    results(index).hiddenUnits = variableParams(index).hiddenUnits;
    results(index).dropout = variableParams(index).dropout;

    results(index).epochs = mean(repeatResultsTab{:, 'epochs'});
    results(index).iterations = mean(repeatResultsTab{:, 'iterations'});
    results(index).elapsedTime = mean(repeatResultsTab{:, 'timeResult'});
    results(index).elapsedTime_HH_MM_SS = datestr(results(index).elapsedTime,'HH:MM:SS');
    results(index).finalValidationLoss = mean(repeatResultsTab{:, 'finalValidationLoss'});
    results(index).finalValidationAccuracy = mean(repeatResultsTab{:, 'finalValidationAccuracy'});
    results(index).losoValidation = mean(repeatResultsTab{:, 'losoValidation'});
    results(index).vLossMean = mean(repeatResultsTab{:, 'vLossMean'});
    results(index).vLossMin = mean(repeatResultsTab{:, 'vLossMin'});
    results(index).vLossMedian = mean(repeatResultsTab{:, 'vLossMedian'});
    results(index).vLossMax = mean(repeatResultsTab{:, 'vLossMax'});
    results(index).vLossStd = mean(repeatResultsTab{:, 'vLossStd'});
    results(index).vAccuracyMean = mean(repeatResultsTab{:, 'vAccuracyMean'});
    results(index).vAccuracyMin = mean(repeatResultsTab{:, 'vAccuracyMin'});
    results(index).vAccuracyMedian = mean(repeatResultsTab{:, 'vAccuracyMedian'});
    results(index).vAccuracyMax = mean(repeatResultsTab{:, 'vAccuracyMax'});
    results(index).vAccuracyStd = mean(repeatResultsTab{:, 'vAccuracyStd'});
    results(index).tLossMean = mean(repeatResultsTab{:, 'tLossMean'});
    results(index).tLossMin = mean(repeatResultsTab{:, 'tLossMin'});
    results(index).tLossMedian = mean(repeatResultsTab{:, 'tLossMedian'});
    results(index).tLossMax = mean(repeatResultsTab{:, 'tLossMax'});
    results(index).tLossStd = mean(repeatResultsTab{:, 'tLossStd'});
    results(index).tAccuracyMean = mean(repeatResultsTab{:, 'tAccuracyMean'});
    results(index).tAccuracyMin = mean(repeatResultsTab{:, 'tAccuracyMin'});
    results(index).tAccuracyMedian = mean(repeatResultsTab{:, 'tAccuracyMedian'});
    results(index).tAccuracyMax = mean(repeatResultsTab{:, 'tAccuracyMax'});
    results(index).tAccuracyStd = mean(repeatResultsTab{:, 'tAccuracyStd'});
    
    results(index).fullTestElapsedTime = fullTestTime;
    results(index).fullTestElapsedTime_HH_MM_SS = fullTestTimeString;
    results(index).trainPerson = join(constParams.trainPerson, ",");
    results(index).validationPerson = join(constParams.validationPerson, ",");
    results(index).crossValidationPerson = join(constParams.crossValidationPerson, ",");
    results(index).validAccuracyPatience = constParams.validAccuracyPatience;
    results(index).maxExpectedValidAccuracy = constParams.maxExpectedValidAccuracy;
    results(index).minExpectedValidLoss = constParams.minExpectedValidLoss;
end