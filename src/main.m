% RGB = imread('..\data\classifierConstructorDataset\BioID_0001.pgm');
RGB = rgb2gray(imread('..\data\classifierConstructorDataset\BioXX_02.jpg'));
load('../data/datasetFeatures.mat');
%load('../data/predictorKnn.mat')
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



