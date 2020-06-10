function [layersMatrix, optionsMatrix, numIterationsPerEpoch] = prepareLSTMParameters(sequencesTrain, labelsTrain, sequencesValidation, labelsValidation, params)

numFeatures = size(sequencesTrain{1},1);
classes = categories(labelsTrain);
numClasses = numel(classes);

variableParams = params.variable;
numTests = size(variableParams, 2);
layersMatrix = [];
optionsMatrix = [];

for i = 1:numTests
    layers = [
        sequenceInputLayer(numFeatures,'Name','sequence')
        bilstmLayer(variableParams(i).hiddenUnits,'OutputMode',variableParams(i).bilstmOutputMode,'Name','bilstm')
        dropoutLayer(variableParams(i).dropout,'Name','drop')
        fullyConnectedLayer(numClasses,'Name','fc')
        softmaxLayer('Name','softmax')
        classificationLayer('Name','classification')];
    
    miniBatchSize = variableParams(i).miniBatchSize;
    numObservations = numel(sequencesTrain);
    numIterationsPerEpoch = floor(numObservations / miniBatchSize);

    options = trainingOptions(variableParams(i).solver, ...
        'MiniBatchSize',miniBatchSize, ...
        'InitialLearnRate',variableParams(i).initialLearnRate, ...
        'GradientThreshold',variableParams(i).gradientThreshold, ...
        'Shuffle',variableParams(i).shuffle, ...
        'MaxEpochs',variableParams(i).maxEpochs, ...
        'ValidationData',{sequencesValidation, labelsValidation}, ...
        'ValidationFrequency',max(numIterationsPerEpoch, 1), ...
        'ValidationPatience', variableParams(i).validationPatience, ...
        'Plots',params.const.plot, ...
        'Verbose',false);
    
    layersMatrix = [layersMatrix, layers];
    optionsMatrix = [optionsMatrix, options];
end

end