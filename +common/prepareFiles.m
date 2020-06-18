function [labelsMap, incorrectLabelsMap, trainListing, validationListing] = prepareFiles(params)

    fileNames = params.fileNames;
    constParams = params.const;
    
    labelsMap = common.prepareLabels(fileNames.labelsCsvFile);
    if (isfile(fileNames.incorrectLabelsCsvFile))
        incorrectLabelsMap = prepareLabels(fileNames.incorrectLabelsCsvFile);
    else
        incorrectLabelsMap = containers.Map;
    end

    [trainListing] = common.prepareListing(fileNames.dataFileListing, labelsMap, constParams.trainPerson);
    [validationListing] = common.prepareListing(fileNames.dataFileListing, labelsMap, constParams.validationPerson);
end