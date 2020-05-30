function [frame] = readGestureFrame(folder, file)
fileName = fullfile(folder, file);
frame = imread(fileName);
end