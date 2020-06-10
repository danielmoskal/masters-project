function [listing] = prepareListing(dataFilelisting, labelsMap)

    fullListing = dir(dataFilelisting);
    numFiles = numel(fullListing);
    listing = struct('folder', fullListing(1).folder, 'name', fullListing(1).name);

    for fileIdx = 2:numFiles
        [~, label] = fileparts(fullListing(fileIdx).folder);
        if isKey(labelsMap, label)
            listing(end+1) = struct('folder', fullListing(fileIdx).folder, 'name', fullListing(fileIdx).name);
        end
    end

end