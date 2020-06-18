function [labels, sequences] = prepareSequence(netCNN, labelsMap, listing, sequencesFile)

inputSize = netCNN.Layers(1).InputSize(1:2);
layerName = "pool5-7x7_s1";

if exist(sequencesFile, 'file')
    fprintf("- Sequences found and loaded from file\n");
    load(sequencesFile, "sequences", "labels")
    return;
end

start = now;

[listingLength, H, W, C, maxSequenceLength, sequencesLength] = common.prepareSizes(listing);

sequences = cell(sequencesLength, 1);
labels = cell(sequencesLength, 1);

gesture = zeros(H, W, C, maxSequenceLength,'uint8');
[~, currentLabel] = fileparts(listing(1).folder);
[~, currentPerson] = fileparts(fileparts(fileparts(listing(1).folder)));
frameIdx = 0;
gestureIdx = 0;
fprintf("Reading sequence %d of %d...\n", gestureIdx+1, sequencesLength)
for imgIdx = 1:listingLength
    [~, label] = fileparts(listing(imgIdx).folder);
    [~, person] = fileparts(fileparts(fileparts(listing(imgIdx).folder)));
    
    if strcmp(label, currentLabel) && strcmp(person, currentPerson)
        frameIdx = frameIdx + 1;
        gesture(:,:,:,frameIdx) = common.readGestureFrame(listing(imgIdx).folder, listing(imgIdx).name);
    else
        if size(gesture, 4) > frameIdx
            gesture(:,:,:, frameIdx + 1:end) = [];
        end
        
        gestureIdx = gestureIdx + 1;        
        gesture = common.centerCrop(gesture, inputSize);
        labels{gestureIdx} = labelsMap(currentLabel);
        sequences{gestureIdx} = activations(netCNN, gesture, layerName, 'OutputAs', 'columns');
        
        fprintf("Reading sequence %d of %d...\n", gestureIdx + 1, sequencesLength)
        gesture = zeros(H, W, C, maxSequenceLength, 'uint8');
        currentLabel = label;
        currentPerson = person;
        frameIdx = 1;
        gesture(:,:,:,frameIdx) = common.readGestureFrame(listing(imgIdx).folder, listing(imgIdx).name);
    end
end

if size(gesture, 4) > frameIdx
    gesture(:,:,:, frameIdx + 1:end) = [];
end
        
gestureIdx = gestureIdx + 1;        
gesture = common.centerCrop(gesture, inputSize);
labels{gestureIdx} = labelsMap(currentLabel);
sequences{gestureIdx} = activations(netCNN, gesture, layerName, 'OutputAs', 'columns');

labels = categorical(labels);
save(sequencesFile,"sequences", "labels", "-v7.3");

stop = now;
timeResult = stop - start;
fprintf("- Reading and saving all sequences took: %s (HH:MM:SS)\n", datestr(timeResult,'HH:MM:SS'))
end