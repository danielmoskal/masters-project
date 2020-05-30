function [gesture] = prepareGesture(listing, person, label, inputSize)

[listingLength, H, W, C, maxSequenceLength, ~] = prepareSizes(listing);
gesture = zeros(H, W, C, maxSequenceLength, 'uint8');

currentLabel = label;
currentPerson = person;
frameIdx = 0;

for imgIdx = 1:listingLength
    [~, label] = fileparts(listing(imgIdx).folder);
    [~, person] = fileparts(fileparts(fileparts(listing(imgIdx).folder)));
    
    if strcmp(label, currentLabel) && strcmp(person, currentPerson)
        frameIdx = frameIdx + 1;
        gesture(:,:,:,frameIdx) = readGestureFrame(listing(imgIdx).folder, listing(imgIdx).name);
    else
        if frameIdx > 0
            if size(gesture, 4) > frameIdx
                gesture(:,:,:, frameIdx + 1:end) = [];
            end
            gesture = centerCrop(gesture, inputSize);   
            frameIdx = 0;
            break;
        end
    end
end

if frameIdx > 0
    if size(gesture, 4) > frameIdx
        gesture(:,:,:, frameIdx + 1:end) = [];
    end
    gesture = centerCrop(gesture, inputSize);   
end

end