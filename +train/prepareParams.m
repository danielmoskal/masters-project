function [fileNames, constParams, variableParams, allParams] = prepareParams(paramsFile)

[paramsCells] = readcell(paramsFile, 'Delimiter', ',');
[paramsLength, ~] = size(paramsCells);

for i = 1:paramsLength
    key = paramsCells{i};
    cellValues = paramsCells(i, 2:end);
    anyChars = any(cellfun(@ischar, cellValues));
    if anyChars
        correctValues = string(cellValues(cellfun(@ischar, cellValues)));
    else
        correctValues = cell2mat(cellValues(cellfun(@isnumeric, cellValues)));
    end
    
    switch key
        case 'trainDataFileListing' 
            trainDataFileListing = correctValues;
        case 'testDataFileListing' 
            testDataFileListing = correctValues;
        case 'sequencesMatFile' 
            sequencesMatFile = correctValues;
        case 'gesturesMatFile' 
            gesturesMatFile = correctValues;
        case 'lstmMatFile' 
            lstmMatFile = correctValues;
        case 'lstmFullMatFile' 
            lstmFullMatFile = correctValues;
        case 'finalNetMatFile' 
            finalNetMatFile = correctValues;
        case 'labelsCsvFile' 
            labelsCsvFile = correctValues;
        case 'incorrectLabelsCsvFile' 
            incorrectLabelsCsvFile = correctValues;
        case 'trainResultsXlsxFile' 
            trainResultsXlsxFile = correctValues;
        case 'trainResultsCsvFile' 
            trainResultsCsvFile = correctValues;
        case 'trainResultsMatFile' 
            trainResultsMatFile = correctValues;
        case 'classifyResultsFolder' 
            classifyResultsFolder = correctValues;
        case 'classifyResultsXlsxFileName' 
            classifyResultsXlsxFileName = correctValues;
        case 'classifyResultsCsvFileName' 
            classifyResultsCsvFileName = correctValues;
        case 'classifyResultsMatFileName' 
            classifyResultsMatFileName = correctValues;
        case 'plot'
            plot = correctValues;
        case 'displaySequencesHistogram'
            displaySequencesHistogram = correctValues;
        case 'onlyCorrectValidationSequence'
            onlyCorrectValidationSequence = correctValues;
        case 'maxAllowedSequenceLength'
            maxAllowedSequenceLength = correctValues;
        case 'assembleNetworks'
            assembleNetworks = correctValues;
        case 'displayFinalNetworkGraph'
            displayFinalNetworkGraph = correctValues;
        case 'performTestClassification'
            performTestClassification = correctValues;    
        case 'saveLSTMNetwork'
            saveLSTMNetwork = correctValues;
        case 'saveLSTMFullData'
            saveLSTMFullData = correctValues;
        case 'saveFinalNetwork'
            saveFinalNetwork = correctValues;
        case 'saveTrainResults'
            saveTrainResults = correctValues;
        case 'saveClassifyResults'
            saveClassifyResults = correctValues;    
        case 'numRepeats'
            numRepeats = correctValues;
        case 'startTestIdx'
            startTestIdx = correctValues;
        case 'bilstmOutputModes'
            bilstmOutputModes = correctValues;
        case 'initialLearnRates'
            initialLearnRates = correctValues;
        case 'gradientThresholds'
            gradientThresholds = correctValues;
        case 'shuffles'
            shuffles = correctValues;
        case 'validationPatiences'
            validationPatiences = correctValues;
        case 'maxEpochs'
            maxEpochs = correctValues;
        case 'miniBatchSizes'
            miniBatchSizes = correctValues;
        case 'solvers'
            solvers = correctValues;
        case 'hiddenUnits'
            hiddenUnits = correctValues;
        case 'dropouts'
            dropouts = correctValues;
        otherwise
            if key(1:2) ~= "//"
                fprintf("%s parameter not found in struct!\n", key);
            end
    end
end

numBilstmOutputModes = size(bilstmOutputModes, 2);
numInitialLearnRates = size(initialLearnRates, 2);
numGradientThresholds = size(gradientThresholds, 2);
numShuffles = size(shuffles, 2);
numValidationPatiences =  size(validationPatiences, 2);
numMaxEpochs = size(maxEpochs, 2);
numMiniBatchSizes = size(miniBatchSizes, 2);
numSolvers = size(solvers, 2);
numHiddenUnits = size(hiddenUnits, 2);
numDropouts = size(dropouts, 2);

numTests = numBilstmOutputModes * numInitialLearnRates * numGradientThresholds * numShuffles * numValidationPatiences * numMaxEpochs * numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;

fileNames = struct(...
    'trainDataFileListing', trainDataFileListing, ...
    'testDataFileListing', testDataFileListing, ...
    'sequencesMatFile', sequencesMatFile, ...
    'gesturesMatFile', gesturesMatFile, ...   
    'lstmMatFile', lstmMatFile, ...
    'lstmFullMatFile', lstmFullMatFile, ...
    'finalNetMatFile', finalNetMatFile, ...
    'labelsCsvFile', labelsCsvFile, ...
    'incorrectLabelsCsvFile', incorrectLabelsCsvFile, ...
    'trainResultsXlsxFile', trainResultsXlsxFile, ...
    'trainResultsCsvFile', trainResultsCsvFile, ...
    'trainResultsMatFile', trainResultsMatFile, ...
    'classifyResultsFolder', classifyResultsFolder, ...
    'classifyResultsXlsxFileName', classifyResultsXlsxFileName, ...
    'classifyResultsCsvFileName', classifyResultsCsvFileName, ...
    'classifyResultsMatFileName', classifyResultsMatFileName);

constParams = struct(...
    'plot', plot, ...
    'displaySequencesHistogram', displaySequencesHistogram, ...
    'onlyCorrectValidationSequence', onlyCorrectValidationSequence, ...   
    'maxAllowedSequenceLength', maxAllowedSequenceLength, ...
    'assembleNetworks', assembleNetworks, ...
    'displayFinalNetworkGraph', displayFinalNetworkGraph, ...
    'performTestClassification', performTestClassification, ...
    'saveLSTMNetwork', saveLSTMNetwork, ...
    'saveLSTMFullData', saveLSTMFullData, ...
    'saveFinalNetwork', saveFinalNetwork, ...
    'saveTrainResults', saveTrainResults, ...
    'saveClassifyResults', saveClassifyResults, ...
    'numRepeats', numRepeats, ...
    'startTestIdx', startTestIdx);

variableParams = struct(...
    'bilstmOutputMode', cell(1, numTests), ...
    'initialLearnRate', cell(1, numTests), ...
    'gradientThreshold', cell(1, numTests), ...
    'shuffle', cell(1, numTests), ...
    'validationPatience', cell(1, numTests), ...
    'maxEpochs', cell(1, numTests), ...
    'miniBatchSize', cell(1, numTests), ...
    'solver', cell(1, numTests), ...
    'hiddenUnits', cell(1, numTests), ...
    'dropout', cell(1, numTests));

allParams = struct(...
    'fileNames', fileNames, ...
    'const', constParams, ...
    'variable', variableParams);

bilstmOutputModesIdx = 1;
initialLearnRatesIdx = 1;
gradientThresholdsIdx = 1;
shufflesIdx = 1;
validationPatiencesIdx = 1;
maxEpochsIdx = 1;
miniBatchSizesIdx = 1;
solversIdx = 1;
hiddenUnitsIdx = 1;
dropoutsIdx = 1;

for i = 1:numTests    
    variableParams(i).bilstmOutputMode = bilstmOutputModes(bilstmOutputModesIdx);
    variableParams(i).initialLearnRate = initialLearnRates(initialLearnRatesIdx);
    variableParams(i).gradientThreshold = gradientThresholds(gradientThresholdsIdx);
    variableParams(i).shuffle = shuffles(shufflesIdx);
    variableParams(i).validationPatience = validationPatiences(validationPatiencesIdx);
    variableParams(i).maxEpochs = maxEpochs(maxEpochsIdx);
    variableParams(i).miniBatchSize = miniBatchSizes(miniBatchSizesIdx);
    variableParams(i).solver = solvers(solversIdx);
    variableParams(i).hiddenUnits = hiddenUnits(hiddenUnitsIdx);
    variableParams(i).dropout = dropouts(dropoutsIdx);
    allParams.variable = variableParams;

    bilstmOutputModesIdx = updateIndex('bilstmOutputModes', bilstmOutputModesIdx, numBilstmOutputModes);
    initialLearnRatesIdx = updateIndex('initialLearnRate', initialLearnRatesIdx, numInitialLearnRates);
    gradientThresholdsIdx = updateIndex('gradientThreshold', gradientThresholdsIdx, numGradientThresholds);
    shufflesIdx = updateIndex('shuffles', shufflesIdx, numShuffles);
    validationPatiencesIdx = updateIndex('validationPatiences', validationPatiencesIdx, numValidationPatiences);
    maxEpochsIdx = updateIndex('maxEpochs', maxEpochsIdx, numMaxEpochs);
    miniBatchSizesIdx = updateIndex('miniBatchSizes', miniBatchSizesIdx, numMiniBatchSizes);
    solversIdx = updateIndex('solvers', solversIdx, numSolvers);
    hiddenUnitsIdx = updateIndex('hiddenUnits', hiddenUnitsIdx, numHiddenUnits);
    
    dropoutsIdx = dropoutsIdx + 1;
    if dropoutsIdx > numDropouts
        dropoutsIdx = 1;
    end
end

function [index] = updateIndex(paramName, index, length)
    multiMod = prepareMultiMod(paramName);
    if mod(i, multiMod) == 0
        index = index + 1;
        if index > length
            index = 1;
        end
    end
end

function [multiMod] = prepareMultiMod(paramName)
    switch paramName
        case 'bilstmOutputModes'
            multiMod = numInitialLearnRates * numGradientThresholds * numShuffles * numValidationPatiences * ...
                numMaxEpochs * numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;
        case 'initialLearnRate'
            multiMod = numGradientThresholds * numShuffles * numValidationPatiences * numMaxEpochs * ...
                numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;
        case 'gradientThreshold'
            multiMod = numShuffles * numValidationPatiences * numMaxEpochs * numMiniBatchSizes * ...
                numSolvers * numHiddenUnits * numDropouts;
        case 'shuffles'
            multiMod = numValidationPatiences * numMaxEpochs * numMiniBatchSizes * numSolvers * ...
                numHiddenUnits * numDropouts;
        case 'validationPatiences'
            multiMod = numMaxEpochs * numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;
        case 'maxEpochs'
            multiMod = numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;
        case 'miniBatchSizes'
            multiMod = numSolvers * numHiddenUnits * numDropouts;
        case 'solvers'
            multiMod = numHiddenUnits * numDropouts;
        case 'hiddenUnits'
            multiMod = numDropouts;
        otherwise
            multiMod = 1;
    end
end

end