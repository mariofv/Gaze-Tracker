%% Clears console and workspace
clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 4;

%% Loads the image
RGB = imread('..\data\originalDataset\BioID_0543.pgm');



%% EYES DETECTION 

%% Loads the classifier
load('..\data\eyeClassification\eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
[eyesImages, eyesPos, possibleEyesPos, centroidsPos] = eyeDetector.detect(RGB, "voting");



%% GAZE DETECTION 

%% Loads the classifier
load('..\data\gazeClassification\gazeClassifier.mat');

%% Creates the objects needed in the detection
featureExtractor = featureExtractorGaze();
classifier = gazeClassifier(classifierTreeBagger, featureExtractor);

gazeDetector = gazeDetector(classifier);

%% Looks for eyes looking at the camera
[personIsLooking, eyesAreLooking] = gazeDetector.detect(eyesImages);

%% Prints the results

% Define the positions and colors of the text boxes.

textPosition = [0 0]; 

if(~isempty(eyesPos))
    RGB = insertMarker(RGB, eyesPos, 'color','green');
    RGB = insertMarker(RGB, eyesPos(eyesAreLooking,:), 'color','blue');
    if(personIsLooking) 
        RGB = insertText(RGB,textPosition,'Person is looking', 'FontSize',18,'BoxColor',...
        {'green'},'BoxOpacity',0.7,'TextColor','white');
    else
        RGB = insertText(RGB,textPosition,'Person is not looking', 'FontSize',18,'BoxColor',...
        {'red'},'BoxOpacity',0.7,'TextColor','white');
    end
else
    RGB = insertText(RGB,textPosition,'No eyes detected', 'FontSize',18,'BoxColor',...
        {'red'},'BoxOpacity',0.7,'TextColor','white');
end

imshow(RGB);
