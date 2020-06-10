function [labels, gestures, gesturesListing] = prepareGestures(labelsMap, listing, inputSize, testGesturesFile)

    if exist(testGesturesFile, 'file')
        load(testGesturesFile, "gestures", "labels", "gesturesListing")
        fprintf("- Gestures found and loaded from file\n");
        if ~exist('gesturesListing', 'var')
            fprintf("- NOT FOUND Gestures listing in gestures mat file\n");
        end
        return;
    end

    start = now;

    [listingLength, H, W, C, maxSequenceLength, sequencesLength] = common.prepareSizes(listing);

    labels = cell(sequencesLength, 1);
    gestures = cell(sequencesLength, 1);
    gesturesListing = cell(sequencesLength, 1);

    gesture = zeros(H, W, C, maxSequenceLength, 'uint8');
    [~, currentLabel] = fileparts(listing(1).folder);
    [~, currentPerson] = fileparts(fileparts(fileparts(listing(1).folder)));
    frameIdx = 0;
    gestureIdx = 0;
    fprintf("Reading gesture %d of %d...\n", gestureIdx+1, sequencesLength)
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
            gestures{gestureIdx} = gesture;
            gesturesListing{gestureIdx} = listing(imgIdx).folder;
        
            fprintf("Reading gesture %d of %d...\n", gestureIdx + 1, sequencesLength)
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
    gestures{gestureIdx} = gesture;
    gesturesListing{gestureIdx} = listing(imgIdx).folder;

    labels = categorical(labels);
    save(testGesturesFile, "gestures", "labels", "gesturesListing", "-v7.3");

    stop = now;
    timeResult = stop - start;
    fprintf("- Reading and saving all gestures took: %s (HH:MM:SS)\n", datestr(timeResult,'HH:MM:SS'))
end