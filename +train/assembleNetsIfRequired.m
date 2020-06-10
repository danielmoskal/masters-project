function [net] = assembleNetsIfRequired(netCNN, netLSTM, constParams)

    if ~constParams.assembleNetworks
        net = [];
        return; 
    end

    %Add Convolutional Layers
    cnnLayers = layerGraph(netCNN);

    layerNames = ["data" "pool5-drop_7x7_s1" "loss3-classifier" "prob" "output"];
    cnnLayers = removeLayers(cnnLayers,layerNames);


    %Add Sequence Input Layer
    inputSize = netCNN.Layers(1).InputSize(1:2);
    averageImage = netCNN.Layers(1).AverageImage;

    inputLayer = sequenceInputLayer([inputSize 3], ...
        'Normalization','zerocenter', ...
        'Mean',averageImage, ...
        'Name','input');

    layers = [
        inputLayer
        sequenceFoldingLayer('Name','fold')];

    netGraph = addLayers(cnnLayers,layers);
    netGraph = connectLayers(netGraph,"fold/out","conv1-7x7_s2");


    %Add LSTM Layers
    lstmLayers = netLSTM.Layers;
    lstmLayers(1) = [];

    layers = [
        sequenceUnfoldingLayer('Name','unfold')
        flattenLayer('Name','flatten')
        lstmLayers];

    netGraph = addLayers(netGraph,layers);
    netGraph = connectLayers(netGraph,"pool5-7x7_s1","unfold/in");

    netGraph = connectLayers(netGraph,"fold/miniBatchSize","unfold/miniBatchSize");


    %Assemble Networks
    if constParams.displayFinalNetworkGraph
        analyzeNetwork(netGraph);
    end
    net = assembleNetwork(netGraph);
    fprintf("- Final network assembled\n");
end
