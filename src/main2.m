%% Clears console and workspace

clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 2;

%% Loads the image
RGB = imread('..\data\classifierConstructorDataset\BioID_0027.pgm'); %27 93 233 745 1000 1313

%% Loads the classificator

load('..\data\eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
[detectedEyesPos,possibleEyesPos] = eyeDetector.detect2(RGB);

%% Prints the results
if(~isempty(possibleEyesPos))
    RGB = insertMarker(RGB, possibleEyesPos, 'color','red');
    if(~isempty(detectedEyesPos))
        RGB = insertMarker(RGB, detectedEyesPos, 'color','green');
    end
end
imshow(RGB);





