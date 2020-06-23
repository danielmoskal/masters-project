function [sequencesTrain, labelsTrain, sequencesValidation, labelsValidation] = prepareTrainingData(sequences, labels, constParams, incorectLabelsMap)

if nargin > 3 && incorectLabelsMap.Count > 0 && constParams.onlyCorrectValidationSequence
    
    labelCells = cellstr(string(labels));
    incorrectLogicalArray = isKey(incorectLabelsMap, labelCells);

    incorrectSequences = sequences(incorrectLogicalArray);
    incorrectLabels = labels(incorrectLogicalArray);

    correctSequences = sequences(~incorrectLogicalArray);
    correctLabels = labels(~incorrectLogicalArray);
    
    correctObservationsLength = numel(correctSequences);
    idx = randperm(correctObservationsLength);
    N = floor(0.9 * correctObservationsLength);

    idxValidation = idx(N+1:end);
    sequencesValidation = correctSequences(idxValidation);
    labelsValidation = correctLabels(idxValidation);

    idxTrain = idx(1:N);
    sequencesTrain = [correctSequences(idxTrain); incorrectSequences];
    labelsTrain = [correctLabels(idxTrain); incorrectLabels];

    numObservationsTrain = numel(sequencesTrain);
    idxTrain = randperm(numObservationsTrain);
    sequencesTrain = sequencesTrain(idxTrain);
    labelsTrain = labelsTrain(idxTrain);
else
    numObservations = numel(sequences);
    idx = randperm(numObservations);
    N = floor(0.9 * numObservations);

    idxTrain = idx(1:N);
    sequencesTrain = sequences(idxTrain);
    labelsTrain = labels(idxTrain);

    idxValidation = idx(N+1:end);
    sequencesValidation = sequences(idxValidation);
    labelsValidation = labels(idxValidation);
    numObservationsTrain = numel(sequencesTrain);
end

sequenceLengths = zeros(1, numObservationsTrain);

for i = 1:numObservationsTrain
    sequence = sequencesTrain{i};
    sequenceLengths(i) = size(sequence,2);
end

if constParams.displaySequencesHistogram
    figure
    histogram(sequenceLengths)
    title("Sequence Lengths")
    xlabel("Sequence Length")
    ylabel("Frequency")
end

idx = sequenceLengths > constParams.maxAllowedSequenceLength;
sequencesTrain(idx) = [];
labelsTrain(idx) = [];

end
