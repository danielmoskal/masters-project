function [listingLength, H, W, C, maxSequenceLength, sequencesLength] = prepareSizes(listing)

    listingLength = numel(listing);

    firstFileName = fullfile(listing(1).folder, listing(1).name);
    firstImg = imread(firstFileName);
    [H, W, ~] = size(firstImg);
    C = 3; % always 3 channels

    [~, currentLabel] = fileparts(listing(1).folder);
    [~, currentPerson] = fileparts(fileparts(fileparts(listing(1).folder)));
    framesLength = 0;
    sequencesLength = 0;
    maxSequenceLength = 0;

    for imgIdx = 1:listingLength
        [~, label] = fileparts(listing(imgIdx).folder);
        [~, person] = fileparts(fileparts(fileparts(listing(imgIdx).folder)));
    
        if strcmp(label, currentLabel) && strcmp(person, currentPerson)
            framesLength = framesLength + 1;
        else
            maxSequenceLength = max(maxSequenceLength, framesLength);
            sequencesLength = sequencesLength + 1;
            currentLabel = label;
            currentPerson = person;
            framesLength = 1;
        end
    end

    maxSequenceLength = max(maxSequenceLength, framesLength);
    sequencesLength = sequencesLength + 1;

end