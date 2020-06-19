function [labelsMap, incorrectLabelsMap, trainListing, validationListing] = prepareFiles(testId, params)

    fileNames = params.fileNames;
    variableParams = params.variable;
    
    labelsMap = common.prepareLabels(fileNames.labelsCsvFile);
    if (isfile(fileNames.incorrectLabelsCsvFile))
        incorrectLabelsMap = prepareLabels(fileNames.incorrectLabelsCsvFile);
    else
        incorrectLabelsMap = containers.Map;
    end
    
    [trainListing] = common.prepareListing(fileNames.dataFileListing, labelsMap, variableParams(testId).trainPerson);
    [validationListing] = common.prepareListing(fileNames.dataFileListing, labelsMap,  variableParams(testId).validPerson);
end