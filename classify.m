[gesture] = prepareGesture(listing, 'PersonC', 'niepoprawne_dowod1_odbior_wczesniej_mozna0000', inputSize);
displayGesture(gesture);
[YPred,scores] = classify(net,{gesture})
classes