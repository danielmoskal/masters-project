clear

[sequencesFile, lstmFile, finalNetFile, lstmFullFile, labelsMap, incorrectLabelsMap, listing] = prepareFiles();

netCNN = googlenet;
inputSize = netCNN.Layers(1).InputSize(1:2);
load(finalNetFile, 'net', 'classes', 'info');

[gesture] = prepareGesture(listing, 'PersonB', 'kiedy_gotowy_dowod10002', inputSize);
displayGesture(gesture);
classes
[YPred,scores] = classify(net,{gesture})
