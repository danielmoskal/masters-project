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
        case 'dataFileListing' 
            dataFileListing = correctValues;
        case 'trainSequencesMatFile' 
            trainSequencesMatFile = correctValues;
        case 'validationSequencesMatFile' 
            validationSequencesMatFile = correctValues;
        case 'crossValidationGesturesMatFile' 
            crossValidationGesturesMatFile = correctValues;
        case 'saveNetsFolder' 
            saveNetsFolder = correctValues;
        case 'lstmMatFileName' 
            lstmMatFileName = correctValues;
        case 'lstmFullMatFileName' 
            lstmFullMatFileName = correctValues;
        case 'finalNetMatFileName' 
            finalNetMatFileName = correctValues;
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
        case 'learnRateSchedule'
            learnRateSchedule = correctValues;
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
        case 'trainPerson'
            trainPerson = correctValues;
        case 'validationPerson'
            validationPerson = correctValues;
        case 'crossValidationPerson'
            crossValidationPerson = correctValues;
        case 'validAccuracyPatience'
            validAccuracyPatience = correctValues;
        case 'maxExpectedValidAccuracy'
            maxExpectedValidAccuracy = correctValues;
        case 'minExpectedValidLoss'
            minExpectedValidLoss = correctValues;
        case 'sequencePaddingDirections'
            sequencePaddingDirections = correctValues;
        case 'bilstmOutputModes'
            bilstmOutputModes = correctValues;
        case 'initialLearnRates'
            initialLearnRates = correctValues;
        case 'learnRateDropPeriods'
            learnRateDropPeriods = correctValues;
        case 'learnRateDropFactors'
            learnRateDropFactors = correctValues;
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

numSequencePaddingDirections = size(sequencePaddingDirections, 2);
numBilstmOutputModes = size(bilstmOutputModes, 2);
numInitialLearnRates = size(initialLearnRates, 2);
numLearnRateDropPeriods = size(learnRateDropPeriods, 2);
numLearnRateDropFactors = size(learnRateDropFactors, 2);
numGradientThresholds = size(gradientThresholds, 2);
numShuffles = size(shuffles, 2);
numValidationPatiences =  size(validationPatiences, 2);
numMaxEpochs = size(maxEpochs, 2);
numMiniBatchSizes = size(miniBatchSizes, 2);
numSolvers = size(solvers, 2);
numHiddenUnits = size(hiddenUnits, 2);
numDropouts = size(dropouts, 2);

numTests = numSequencePaddingDirections * numBilstmOutputModes * numInitialLearnRates * numLearnRateDropPeriods * numLearnRateDropFactors * numGradientThresholds * numShuffles * numValidationPatiences * numMaxEpochs * numMiniBatchSizes * numSolvers * numHiddenUnits * numDropouts;

fileNames = struct(...
    'dataFileListing', dataFileListing, ...
    'trainSequencesMatFile', trainSequencesMatFile, ...
    'validationSequencesMatFile', validationSequencesMatFile, ...
    'crossValidationGesturesMatFile', crossValidationGesturesMatFile, ...
    'saveNetsFolder', saveNetsFolder, ...
    'lstmMatFileName', lstmMatFileName, ...
    'lstmFullMatFileName', lstmFullMatFileName, ...
    'finalNetMatFileName', finalNetMatFileName, ...
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
    'learnRateSchedule', learnRateSchedule, ...
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
    'startTestIdx', startTestIdx, ...
    'trainPerson', trainPerson, ...
    'validationPerson', validationPerson, ...
    'crossValidationPerson', crossValidationPerson, ...
    'validAccuracyPatience', validAccuracyPatience, ...
    'maxExpectedValidAccuracy', maxExpectedValidAccuracy, ...
    'minExpectedValidLoss', minExpectedValidLoss);

variableParams = struct(...
    'sequencePaddingDirection', cell(1, numTests), ...
    'bilstmOutputMode', cell(1, numTests), ...
    'initialLearnRate', cell(1, numTests), ...
    'learnRateDropPeriod', cell(1, numTests), ...
    'learnRateDropFactor', cell(1, numTests), ...
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
sequencePaddingDirectionIdx = 1;
initialLearnRatesIdx = 1;
learnRateDropPeriodIdx = 1;
learnRateDropFactorIdx = 1;
gradientThresholdsIdx = 1;
shufflesIdx = 1;
validationPatiencesIdx = 1;
maxEpochsIdx = 1;
miniBatchSizesIdx = 1;
solversIdx = 1;
hiddenUnitsIdx = 1;
dropoutsIdx = 1;

for i = 1:numTests    
    variableParams(i).sequencePaddingDirection = sequencePaddingDirections(sequencePaddingDirectionIdx);
    variableParams(i).bilstmOutputMode = bilstmOutputModes(bilstmOutputModesIdx);
    variableParams(i).initialLearnRate = initialLearnRates(initialLearnRatesIdx);
    variableParams(i).learnRateDropPeriod = learnRateDropPeriods(learnRateDropPeriodIdx);
    variableParams(i).learnRateDropFactor = learnRateDropFactors(learnRateDropFactorIdx);
    variableParams(i).gradientThreshold = gradientThresholds(gradientThresholdsIdx);
    variableParams(i).shuffle = shuffles(shufflesIdx);
    variableParams(i).validationPatience = validationPatiences(validationPatiencesIdx);
    variableParams(i).maxEpochs = maxEpochs(maxEpochsIdx);
    variableParams(i).miniBatchSize = miniBatchSizes(miniBatchSizesIdx);
    variableParams(i).solver = solvers(solversIdx);
    variableParams(i).hiddenUnits = hiddenUnits(hiddenUnitsIdx);
    variableParams(i).dropout = dropouts(dropoutsIdx);
    allParams.variable = variableParams;

    sequencePaddingDirectionIdx = updateIndex('sequencePaddingDirection', sequencePaddingDirectionIdx, numSequencePaddingDirections);
    bilstmOutputModesIdx = updateIndex('bilstmOutputModes', bilstmOutputModesIdx, numBilstmOutputModes);
    initialLearnRatesIdx = updateIndex('initialLearnRate', initialLearnRatesIdx, numInitialLearnRates);
    learnRateDropPeriodIdx = updateIndex('learnRateDropPeriod', learnRateDropPeriodIdx, numLearnRateDropPeriods);
    learnRateDropFactorIdx = updateIndex('learnRateDropFactor', learnRateDropFactorIdx, numLearnRateDropFactors);
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
        case 'sequencePaddingDirection'
            multiMod = numBilstmOutputModes * prepareMultiMod('bilstmOutputModes');
        case 'bilstmOutputModes'
            multiMod = numInitialLearnRates * prepareMultiMod('initialLearnRate');
        case 'initialLearnRate'
            multiMod = numLearnRateDropPeriods * prepareMultiMod('learnRateDropPeriod');
        case 'learnRateDropPeriod'
            multiMod = numLearnRateDropFactors * prepareMultiMod('learnRateDropFactor');
        case 'learnRateDropFactor'
            multiMod = numGradientThresholds * prepareMultiMod('gradientThreshold');
        case 'gradientThreshold'
            multiMod = numShuffles * prepareMultiMod('shuffles');
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