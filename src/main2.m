%% Clears console and workspace

clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 2;

%% Loads the image
RGB = imread('..\data\classifierConstructorDataset\BioID_0233.pgm'); %27 93

%% Loads the classificator

load('..\data\eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
eyesPos = eyeDetector.detect2(RGB);

%% Prints the results
hold on
markedRGB = insertMarker(RGB, eyesPos, 'color','green'); 
imshow(markedRGB);
hold off




