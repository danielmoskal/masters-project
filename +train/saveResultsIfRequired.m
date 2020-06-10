function [] = saveResultsIfRequired(params, results, globalInfos)

    if ~params.const.saveTrainResults
        return;
    end

    fileNames = params.fileNames;
    resultsTab = struct2table(results, 'AsArray', true);
    writetable(resultsTab, fileNames.trainResultsXlsxFile);
    writetable(resultsTab, fileNames.trainResultsCsvFile);
    save(fileNames.trainResultsMatFile, "results", "globalInfos", "-v7.3");
    fprintf("- Train results saved\n");
end