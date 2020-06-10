clear
fullClassifyStart = now;

netCNN = googlenet;
inputSize = netCNN.Layers(1).InputSize(1:2);

dataFilelisting = "D:\Dane do pracy dyplomowej\sigexp_tests\*\*\*\*.jpeg";
dataFolder = "D:\Dane do pracy dyplomowej\sigexp_tests";
testGesturesFile = fullfile(dataFolder, "DATA\sigexp_gestures.mat");
finalNetFile = fullfile(dataFolder, "DATA\sigexp_final_net.mat");
labelsFile = fullfile(dataFolder, "DATA\labels.csv");
[labelsMap] = common.prepareLabels(labelsFile);
[listing] = common.prepareListing(dataFilelisting, labelsMap);

load(finalNetFile, 'net', 'classes', 'info');
[labels, gestures, gesturesListing] = common.prepareGestures(labelsMap, listing, inputSize, testGesturesFile);

numGestures = size(gestures, 1);
numHits = 0;

for i = 1:numGestures
    fprintf("Try to classify for gesture %d of %d...", i, numGestures);
    classifyStart = now;
    
    [YPred,scores] = classify(net,{gestures{i}});
    if YPred == labels(i)
        numHits = numHits + 1;
        fprintf("(Hit! Current result %.2f)", numHits / i);
    end
    
    % common.displayGesture(gesture);
    % classes
    
    classifyStop = now;
    [classifyTime, classifyTimeString] = common.calculateTimeResult(classifyStart, classifyStop);
    [~, elapsedTimeString, timeStampString] = common.calculateTimeResult(fullClassifyStart, classifyStop);
    fprintf(", classify time(HH:MM:SS): %s, elapsed time: %s, time stamp: %s\n", classifyTimeString, elapsedTimeString, timeStampString);
end

classifyResult = numHits / numGestures;

fullClassifyStop = now;
[~, fullClassifyTimeString, timeStampString] = common.calculateTimeResult(fullClassifyStart, fullClassifyStop);
fprintf("Classify finished with time(HH:MM:SS.FFF): %s, time stamp: %s\n", fullClassifyTimeString, timeStampString);
classifyResult