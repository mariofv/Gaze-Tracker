RGB = imread('prova.pgm');
load('../data/datasetFeatures.mat');

splitter = imageSplitter(64);

modelTreeBagger = fitcknn(trainingFeatures,trainingClasses,'NumNeighbors', 1);
featureExtractor = featureExtractor();
classifier = eyeClassifier(modelTreeBagger,featureExtractor);

eyeDetector = eyesDetector(classifier,splitter);

eyesPos = eyeDetector.detect(RGB);

RGB = insertMarker(RGB, eyesPos);
figure();imshow(RGB);

