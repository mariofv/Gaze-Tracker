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
markedRGB = insertMarker(RGB, possibleEyesPos, 'color','green'); 
imshow(markedRGB);
hold off

%% Extracts true eyes positions using HOUGH
rad = round(subImageSize/2);

[x,y] = size(RGB);

A = zeros(x, y);

% Main loop
for i = 1:size(possibleEyesPos,1)
    for theta = 0:359  
        a = round(possibleEyesPos(i,1) - rad * cos(deg2rad(theta))); % polar coordinate for center
        b = round(possibleEyesPos(i,2) - rad * sin(deg2rad(theta)));  % polar coordinate for center 
        if b == 4748
            c=2;
        end
        A(a,b) = A(a,b) + 1; % voting
    end
end

% Finds the most voted centers
firstMaxValue = max(max(max(A)));
[firstEyeX, firstEyeY] = find(A==firstMaxValue);
firstEyeCenter = [firstEyeX, firstEyeY];
A(firstEyeX, firstEyeY) = -1;

secondMaxValue = max(max(max(A)));
[secondEyeX, secondEyeY] = find(A==secondMaxValue);
secondEyeCenter = [secondEyeX, secondEyeY];

%% Prints the results
hold on
markedRGB = insertMarker(RGB, [firstEyeCenter;secondEyeCenter], 'color','green'); 
markedRGB = insertMarker(markedRGB, possibleEyesPos, 'color','red'); 
imshow(markedRGB);
hold off
