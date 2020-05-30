clear

onlyCorrectValidationSequence = true;

netCNN = googlenet;

[sequencesFile, lstmFile, finalNetFile, lstmFullFile, labelsMap, incorrectLabelsMap, listing] = prepareFiles();
[labels, sequences] = prepareSequences(netCNN, labelsMap, listing, sequencesFile);
[sequencesTrain, labelsTrain, sequencesValidation, labelsValidation] = prepareTrainingData(sequences, labels, incorrectLabelsMap, onlyCorrectValidationSequence);


%Create LSTM Network
numFeatures = size(sequencesTrain{1},1);
classes = categories(labelsTrain);
numClasses = numel(classes);

layers = [
    sequenceInputLayer(numFeatures,'Name','sequence')
    bilstmLayer(2000,'OutputMode','last','Name','bilstm')
    dropoutLayer(0.5,'Name','drop')
    fullyConnectedLayer(numClasses,'Name','fc')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classification')];


%Specify Training Options
miniBatchSize = 16;
numObservations = numel(sequencesTrain);
numIterationsPerEpoch = floor(numObservations / miniBatchSize);

options = trainingOptions('adam', ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',1e-4, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'MaxEpochs',50, ...
    'ValidationData',{sequencesValidation,labelsValidation}, ...
    'ValidationFrequency',numIterationsPerEpoch, ...
    'Plots','training-progress', ...
    'Verbose',false);


%Train LSTM Network
[netLSTM, info] = trainNetwork(sequencesTrain,labelsTrain,layers,options);

YPred = classify(netLSTM,sequencesValidation,'MiniBatchSize',miniBatchSize);
YValidation = labelsValidation;
accuracy = mean(YPred == YValidation)

%Save LSTM results to files
save(lstmFile,"netLSTM", "info", "accuracy", "classes", "-v7.3");
save(lstmFullFile, "-v7.3");


%Assemble Networks
[net] = assembleNets(netCNN, netLSTM);

%Save final net results to file
save(finalNetFile,"net", "classes", "info", "-v7.3");