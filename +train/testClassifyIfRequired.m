function [classifyResult] = testClassifyIfRequired(params, labelsMap, net, classes, inputSize, testId, repeatId)

    constParams = params.const;

    if ~constParams.performTestClassification || ~constParams.assembleNetworks
        return; 
    end
    
    fullClassifyStart = now;
    fileNames = params.fileNames;
    variableParams = params.variable;

    [listing] = common.prepareListing(fileNames.dataFileListing, labelsMap, variableParams(testId).losoPerson);
    
    
    fprintf("- Prepare loso valid gestures... (person-%s)\n", variableParams(testId).losoPersonShortString);
    
    filePrefix = sprintf("person-%s_", variableParams(testId).losoPersonShortString);
    if constParams.trainOnDepthMaps
        filePrefix = sprintf("depth_%s", filePrefix);
    end
    gestureMatFile = fullfile(fileNames.sequencesFolder, filePrefix + fileNames.crossValidationGesturesMatFileName);
    [labels, gestures, gesturesListing] = common.prepareGestures(labelsMap, listing, inputSize, gestureMatFile, constParams.trainOnDepthMaps);
    
    fprintf("- Loso valid gestures prepared!\n");
    
    
    numGestures = size(gestures, 1);
    numClasses = size(classes, 1);
    numHits = 0;
    lineLength = 0;
    
    scores = cell(numGestures, numClasses);
    YPreds = cell(numGestures, 1);

    for i = 1:numGestures
        if lineLength > 0
            fprintf(repmat('\b',1,lineLength))
        end
        lineLength = fprintf("Test classify for gesture %d of %d...\n", i, numGestures);
    
        [YPred, score] = classify(net,{gestures{i}});
        scores(i, :) = arrayfun(@(x)round(x, 4), score, 'UniformOutput', false);
        YPreds(i) = cellstr(string(YPred));
        
        if YPred == labels(i)
            numHits = numHits + 1;
        end
    end

    classifyResult = numHits / numGestures;
    
    fullClassifyStop = now;
    [fullClassifyTime, fullClassifyTimeString, timeStampString] = common.calculateTimeResult(fullClassifyStart, fullClassifyStop);
   
    fprintf("- Classify finished with time(HH:MM:SS): %s, time stamp: %s\n", fullClassifyTimeString, timeStampString);
    fprintf("- Classify result: %.2f\n", classifyResult);
    
    saveClassifyResultsIfRequired();
    
    
    function [] = saveClassifyResultsIfRequired()
        if ~constParams.saveClassifyResults
            return;
        end
        
        labelsCell = cellstr(string(labels));
        classifyResultsCell = num2cell(repmat(classifyResult, numGestures, 1));
        fullClassifyTimes = num2cell(repmat(fullClassifyTime, numGestures, 1));
        fullClassifyTimeStrings = cellstr(repmat(fullClassifyTimeString, numGestures, 1));
        emptyCell = cell(numGestures, 1);
        
        mergedCellKeys = [{'actualLabel', 'predictLabel', 'SCORES'}, classes', {'MERGED', 'globalResult', 'fullClassifyElapsedTime', 'fullClassifyElapsedTime_HH_MM_SS', 'gestureFolder'}];
        mergedCellValues = [labelsCell, YPreds, emptyCell, scores, emptyCell, classifyResultsCell, fullClassifyTimes, fullClassifyTimeStrings, gesturesListing];
        classifyResultsTable = cell2table(mergedCellValues, 'VariableNames', mergedCellKeys);

        fileNamePrefix = sprintf("test-%d_repeat-%d_", testId, repeatId);
        xlsxFile = fullfile(fileNames.classifyResultsFolder, fileNamePrefix + fileNames.classifyResultsXlsxFileName);
        csvFile = fullfile(fileNames.classifyResultsFolder, fileNamePrefix + fileNames.classifyResultsCsvFileName);
        matFile = fullfile(fileNames.classifyResultsFolder, fileNamePrefix + fileNames.classifyResultsMatFileName);
        
        writetable(classifyResultsTable, xlsxFile);
        writetable(classifyResultsTable, csvFile);
        save(matFile, "classifyResultsTable", "scores", "YPreds", "labels", "classifyResult", "-v7.3");
        fprintf("- Classify results saved\n");
    end
end
