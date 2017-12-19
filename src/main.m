%% Loads the image
RGB = rgb2gray(imread('..\data\classifierConstructorDataset\BioXX_02.jpg'));

%% Loads the classificator

load('../data/eyeClassifier.mat');

%% Creates the objects needed in the classification
splitter = imageSplitter(32, 4);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
eyesPos = eyeDetector.detect(RGB);
[images,centerPos] = splitter.split(RGB);


%% Prints the results
hold on
RGB = insertMarker(RGB, eyesPos, 'color','green'); 
imshow(RGB);
hold off



