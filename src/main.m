%% Clears console and workspace

clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 4;

%% Loads the image
RGB = imread('..\data\classifierConstructorDataset\BioID_0027.pgm');

%% Loads the classificator

load('..\data\eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
% Detects all possible eyes
possibleEyesPos = eyeDetector.detect(RGB);


%% Prints the results
hold on
RGB = insertMarker(RGB, possibleEyesPos, 'color','green'); 
imshow(RGB);
hold off

%% Extracts true eyes positions using HOUGH
