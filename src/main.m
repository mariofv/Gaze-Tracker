RGB = imread('prova.jpg');
im = rgb2gray(RGB);
load('../data/datasetFeatures.mat');

splitter = imageSplitter(64);

modelTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses); % TreeBagger
classifier = eyeClassifier(modelTreeBagger);

eyeDetector = eyesDetector(classifier,splitter);

eyesPos = eyeDetector.detect(im);

imshow(insertMarker(RGB, eyesPos));

