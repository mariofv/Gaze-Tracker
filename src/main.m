%% Clears console and workspace

clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 4;

%% Loads the image
RGB = imread('..\data\classifierConstructorDataset\BioID_0047.pgm');

%% Loads the classificator

load('..\data\eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
eyesPos = eyeDetector.detect(RGB);

%% Prints the results
hold on
markedRGB = insertMarker(RGB, eyesPos, 'color','green'); 
imshow(markedRGB);
hold off
