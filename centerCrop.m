function gestureResized = centerCrop(gesture, inputSize)

sz = size(gesture);

if sz(1) < sz(2)
    % landscape
    idx = floor((sz(2) - sz(1))/2);
    gesture(:,1:(idx-1),:,:) = [];
    gesture(:,(sz(1)+1):end,:,:) = [];
    
elseif sz(2) < sz(1)
    % portrait
    idx = floor((sz(1) - sz(2))/2);
    gesture(1:(idx-1),:,:,:) = [];
    gesture((sz(2)+1):end,:,:,:) = [];
end

gestureResized = imresize(gesture,inputSize(1:2));

end