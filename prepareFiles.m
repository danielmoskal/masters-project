function [sequencesFile, lstmFile, finalNetFile, lstmFullFile, labelsMap, incorrectLabelsMap, listing] = prepareFiles()

dataFolder = "D:\Dane do pracy dyplomowej\sigexp";
sequencesFile = fullfile(dataFolder,"DATA\sigexp_sequences.mat");
lstmFile = fullfile(dataFolder,"DATA\sigexp_LSTM.mat");
lstmFullFile = fullfile(dataFolder,"DATA\sigexp_LSTM_full.mat");
finalNetFile = fullfile(dataFolder,"DATA\sigexp_final_net.mat");
labelsFileName = fullfile(dataFolder, 'DATA\labels.csv');
incorrectLabelsFileName = fullfile(dataFolder, 'DATA\incorrectLabels.csv');

fileExtension = ".jpeg";
fullListing = dir(fullfile(dataFolder, "*", "*", "*", "*" + fileExtension));
imagesLength = numel(fullListing);

labelsMap = prepareLabels(labelsFileName);
if (isfile(incorrectLabelsFileName))
    incorrectLabelsMap = prepareLabels(incorrectLabelsFileName);
else
    incorrectLabelsMap = containers.Map;
end


listing = struct('folder', fullListing(1).folder, 'name', fullListing(1).name);

for imgIdx = 2:imagesLength
    [~, label] = fileparts(fullListing(imgIdx).folder);
    if isKey(labelsMap, label)
        listing(end+1) = struct('folder', fullListing(imgIdx).folder, 'name', fullListing(imgIdx).name);
    end
end

end