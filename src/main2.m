%% Clears console and workspace

clc;
clear;

%% Search eyes in the image
% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 2;

% Loads the image
RGB = imread('..\data\originalDataset\BioID_1313.pgm'); %27 93 233 745 1000 1313

% Loads the classificator
load('..\data\eyeClassification\eyeClassifier.mat');

% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

% Looks for the eyes in the image
[detectedEyesPos,possibleEyesPos] = eyeDetector.detect2(RGB);

%% Detect looking eyes
% Loads the classificator
load('..\data\gazeClassification\lookClassifier.mat');

% Creates the objects needed in the detection
lookDetector = lookDetector(classifierTreeBagger);

detectedLookingPos = [];
if(~isempty(detectedEyesPos))
    detectedLookingPos = lookDetector.detect(RGB,detectedEyesPos);
end

%% Prints the results
if(~isempty(possibleEyesPos))
    RGB = insertMarker(RGB, possibleEyesPos, 'color','red');
    if(~isempty(detectedEyesPos))
        RGB = insertMarker(RGB, detectedEyesPos, 'color','green');
        if(~isempty(detectedLookingPos))
            RGB = insertMarker(RGB, detectedEyesPos, 'color','blue');
        end
    end
end
imshow(RGB);

