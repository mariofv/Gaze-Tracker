%% Clears console and workspace

clc;
clear;

%% Initializes some usefull variables
subImageSize = 32;
subImageSampleFreq = 4;

%% Loads the image
RGB = imread('..\data\classifierConstructorDataset\BioID_0027.pgm');

%% Loads the classificator

load('../data/eyeClassifier.mat');

%% Creates the objects needed in the detection
splitter = imageSplitter(subImageSize, subImageSampleFreq);

featureExtractor = featureExtractor();
classifier = eyeClassifier(classifierTreeBagger, featureExtractor);

eyeDetector = eyeDetector(classifier,splitter);

%% Looks for the eyes in the image
% Detects all possible eyes
possibleEyesPos = eyeDetector.detect(RGB);

% Gets the centroids of the possible eyes
clusterInfluenceRange = 1;
centroidsPos = subclust(possibleEyesPos,clusterInfluenceRange);

% Gets the eyes positions
threshold = 1.5*subImageSize;
eyesPos = findAlignedPoints(centroidsPos, threshold);

%% Prints the results
hold on
RGB = insertMarker(RGB, centroidsPos, 'color','green'); 
imshow(RGB);
hold off

% Returns the pairs of horitzontally aligned points if any. 
function [alignedPoints] = findAlignedPoints(points, threshold)
    alignedPoints = zeros(size(points,1), 2);
    for i=1:size(points)
        pointAlignedPoints = points(...
                points(:,1) ~= points(i,1) & ...
                points(:,2) > points(i,2) - threshold & ...
                points(:,2) < points(i,2) + threshold ...
            ,:);
        if size(pointAlignedPoints,1) == 0
            pointAlignedPoints = [-1, -1];
        end
        alignedPoints(i, :) = pointAlignedPoints;
        
    end
end
