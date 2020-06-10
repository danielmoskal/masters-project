function [] = displayGesture(gesture)

numFrames = size(gesture, 4);
figure
for i = 1:numFrames
    frame = gesture(:,:,:,i);
    imshow(frame);
    drawnow
end

% implay(video/255)

end