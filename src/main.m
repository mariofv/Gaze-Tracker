%% Clears console and workspace
clc;
clear;

%% Initializes some usefull variables
subImageSampleFreq = 2;
textPosition = [0 0]; 

% Loads the image
RGB = imread('..\data\originalDataset\BioID_1313.pgm'); %27 93 233 235 745 1000 1313
% RGB = rgb2gray(imread('..\data\originalDataset\BioXX_03.jpg')); %00 01 02
% RGB = rgb2gray(imread('..\data\originalDataset\BioXX_04.jpeg')); %04

[y,x] = size(RGB);
subImageSize = round(y/10);
%subImageSize = 32
%% EYES DETECTION 

% Loads the classifier
load('..\data\eyeClassification\eyeClassifier.mat');

% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

% Looks for the eyes in the image
[eyesImages, eyesPos, possibleEyesPos, centroidsPos] = eyeDetector.detect(RGB, "voting"); % You can choose between "voting" and "cluster"

if(size(eyesPos) ~= 2)
    if size(centroidsPos) ~= 0
        RGB = insertMarker(RGB, centroidsPos, 'color','red');
    end
    RGB = insertText(RGB,textPosition,'No eyes detected', 'FontSize',18,'BoxColor',...
        {'red'},'BoxOpacity',0.7,'TextColor','white');
else      
    %% GAZE DETECTION 

    % Loads the classifier
    load('..\data\gazeClassification\gazeClassifier.mat');

    % Creates the objects needed in the detection
    featureExtractor = featureExtractorGaze();
    classifier = gazeClassifier(classifierTreeBagger, featureExtractor);

    gazeDetector = gazeDetector(classifier);

    % Looks for eyes looking at the camera
    [personIsLooking, eyesAreLooking] = gazeDetector.detect(eyesImages);

    %% Prints the results

    % Define the positions and colors of the text boxes.

    if(size(eyesPos) == 2)
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
    
end



imshow(RGB);
