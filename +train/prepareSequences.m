function [trainSequences, trainLabels, validationSequences, validationlabels] = prepareSequences(netCNN, labelsMap, trainListing, validationListing, params)

    fileNames = params.fileNames;
    constParams = params.const;
    
    fprintf("- Prepare train sequences...\n");
    [trainLabels, trainSequences] = train.prepareSequence(netCNN, labelsMap, trainListing, fileNames.trainSequencesMatFile);
    fprintf("- Train sequences prepared!\n");

    fprintf("- Prepare validation sequences...\n");
    [validationlabels, validationSequences] = train.prepareSequence(netCNN, labelsMap, validationListing, fileNames.validationSequencesMatFile);
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