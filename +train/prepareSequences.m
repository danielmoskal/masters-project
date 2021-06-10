function [trainSequences, trainLabels, validationSequences, validationlabels] = prepareSequences(netCNN, labelsMap, trainListing, validationListing, params, testId)

    fileNames = params.fileNames;
    constParams = params.const;
    variableParams = params.variable;

    
    fprintf("- Prepare train sequences... (person-%s)\n", variableParams(testId).trainPersonShortString);
    
    filePrefix = sprintf("person-%s_", variableParams(testId).trainPersonShortString);
    if constParams.trainOnDepthMaps
        filePrefix = sprintf("depth_%s", filePrefix);
    end
    trainSeuqienceMatFile = fullfile(fileNames.sequencesFolder, filePrefix + fileNames.trainSequencesMatFileName);
    [trainLabels, trainSequences] = train.prepareSequence(netCNN, labelsMap, trainListing, trainSeuqienceMatFile, constParams.trainOnDepthMaps);
    
    fprintf("- Train sequences prepared!\n");

    
    fprintf("- Prepare validation sequences... (person-%s)\n", variableParams(testId).validPersonShortString);
    
    filePrefix = sprintf("person-%s_", variableParams(testId).validPersonShortString);
    if constParams.trainOnDepthMaps
        filePrefix = sprintf("depth_%s", filePrefix);
    end
    validSeuqienceMatFile = fullfile(fileNames.sequencesFolder, filePrefix + fileNames.validationSequencesMatFileName);
    [validationlabels, validationSequences] = train.prepareSequence(netCNN, labelsMap, validationListing, validSeuqienceMatFile, constParams.trainOnDepthMaps);
    
    fprintf("- Validation sequences prepared!\n");


    numTrainObservations = numel(trainSequences);
    idx = randperm(numTrainObservations);
    trainSequences = trainSequences(idx);
    trainLabels = trainLabels(idx);
    
    numValidationObservations = numel(validationSequences);
    idx = randperm(numValidationObservations);
    validationSequences = validationSequences(idx);
    validationlabels = validationlabels(idx);

    trainSequenceLengths = zeros(1, numTrainObservations);
    validationSequenceLengths = zeros(1, numValidationObservations);

    [trainSequenceLengths, validationSequenceLengths] = calculateSequencesLength();
    displaySequencesHistogramIfRequired(constParams, trainSequenceLengths, validationSequenceLengths);
    cutTooLongSequences();
    
    function [] = cutTooLongSequences()

        trainIdx = trainSequenceLengths > constParams.maxAllowedSequenceLength;
        trainSequences(trainIdx) = [];
        trainLabels(trainIdx) = [];
    
        validationIdx = validationSequenceLengths > constParams.maxAllowedSequenceLength;
        validationSequences(validationIdx) = [];
        validationlabels(validationIdx) = [];
        
        if any(trainIdx) || any(validationIdx)
            [trainSequenceLengths, validationSequenceLengths] = calculateSequencesLength();
            displaySequencesHistogramIfRequired(constParams, trainSequenceLengths, validationSequenceLengths, "after cutting too long sequences");
        end
    end



    function [trainSequenceLengths, validationSequenceLengths] = calculateSequencesLength()
        numTrainObservations = numel(trainSequences);
        numValidationObservations = numel(validationSequences);
        
        trainSequenceLengths = zeros(1, numTrainObservations);
        validationSequenceLengths = zeros(1, numValidationObservations);

        for i = 1:numTrainObservations
            sequence = trainSequences{i};
            trainSequenceLengths(i) = size(sequence,2);
        end
    
        for i = 1:numValidationObservations
            sequence = validationSequences{i};
            validationSequenceLengths(i) = size(sequence,2);
        end
    end
    
end

function [] = displaySequencesHistogramIfRequired(constParams, trainSequenceLengths, validationSequenceLengths, suffixTitle)

    if ~constParams.displaySequencesHistogram
        return;
    end
    
    if nargin == 3
        suffixTitle = "";
    end

    figure;
    histogram(trainSequenceLengths)
    title("Train Sequence Lengths " + suffixTitle)
    xlabel("Sequence Length")
    ylabel("Frequency")
        
    figure;
    histogram(validationSequenceLengths)
    title("Validation Sequence Lengths " + suffixTitle)
    xlabel("Sequence Length")
    ylabel("Frequency")
end