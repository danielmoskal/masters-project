function [labelsMap, incorrectLabelsMap, listing] = prepareFiles(fileNames)

    labelsMap = common.prepareLabels(fileNames.labelsCsvFile);
    if (isfile(fileNames.incorrectLabelsCsvFile))
        incorrectLabelsMap = prepareLabels(fileNames.incorrectLabelsCsvFile);
    else
        incorrectLabelsMap = containers.Map;
    end

    [listing] = common.prepareListing(fileNames.trainDataFileListing, labelsMap);
end