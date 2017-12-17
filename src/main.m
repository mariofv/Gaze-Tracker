RGB = imread('prova.pgm');
load('../data/datasetFeatures.mat');
load('../data/predictorKnn.mat')
splitter = imageSplitter(32);

modelTreeBagger = TreeBagger(100,trainingFeatures,trainingClasses);
featureExtractor = featureExtractor();
classifier = eyeClassifier(modelTreeBagger,featureExtractor);

eyeDetector = eyesDetector(classifier,splitter);

eyesPos = eyeDetector.detect(RGB);
[images,centerPos] = splitter.split(RGB);

hold on
%RGB = insertMarker(RGB, centerPos, 'color','red');
RGB = insertMarker(RGB, eyesPos, 'color','green'); 
imshow(RGB);
hold off



