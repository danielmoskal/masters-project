clear
[depth1, mapDepth1] = imread('depth0000.png');
ir1 = imread('ir0000.png');
rgb1 = imread('rgb0000.jpeg');
[indexedRgb, map] = imread('ndexedDepthImage.tif');

% [X,map] = rgb2ind(rgb1, 256);
% imwrite(X,map,'ndexedDepthImage.tif');

depth1Small = im2uint8(depth1);
depthtoRGB = cat(3,depth1Small,depth1Small,depth1Small);
imwrite(depthtoRGB,'depthtoRGB.png');