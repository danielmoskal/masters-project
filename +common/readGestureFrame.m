function [frame] = readGestureFrame(folder, file, trainOnDepthMaps)
   
    fileName = fullfile(folder, file);
    frame = imread(fileName);
    
    if trainOnDepthMaps
        depthFrame8Bit = im2uint8(frame);
        frame = cat(3,depthFrame8Bit, depthFrame8Bit, depthFrame8Bit);
    end
end