function [listing] = prepareListing(dataFilelisting, labelsMap, personStringArray)

    fullListing = dir(dataFilelisting);
    numFiles = numel(fullListing);

    for fileIdx = 1:numFiles
        [~, person] = fileparts(fileparts(fileparts(fullListing(fileIdx).folder)));
        person = string(person);
        [~, label] = fileparts(fullListing(fileIdx).folder);
        
        if any(strcmp(personStringArray, person)) && isKey(labelsMap, label)
            if ~exist('listing', 'var')
                listing = struct('folder', fullListing(fileIdx).folder, 'name', fullListing(fileIdx).name);
            else
                listing(end+1) = struct('folder', fullListing(fileIdx).folder, 'name', fullListing(fileIdx).name);
            end
        end
    end

end