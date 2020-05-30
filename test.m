clear

% netCNN = googlenet;
% inputSize = netCNN.Layers(1).InputSize(1:2);

[sequencesFile, lstmFile, finalNetFile, lstmFullFile, labelsMap, incorectLabelsMap, listing] = prepareFiles();
% load(finalNetFile, 'net', 'classes', 'info');
% 
% [gesture] = prepareGesture(listing, 'PersonB', 'kiedy_gotowy_dowod10002', inputSize);
% displayGesture(gesture);
% [YPred,scores] = classify(net,{gesture})
% classes