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

%% Extracts true eyes positions
[x,y] = size(RGB);

A = zeros(x, y);

M = [0 0 0 0 0 1 1 1 1 1 0 0 0 0 0;
     0 0 0 1 1 2 2 2 2 2 1 1 0 0 0;
     0 0 1 2 2 3 3 3 3 3 2 2 1 0 0;
     0 1 2 2 3 4 4 4 4 4 3 2 2 1 0;
     0 1 2 3 4 4 5 5 5 4 4 3 2 1 0;
     1 2 3 4 4 5 6 6 6 5 4 4 3 2 1;
     1 2 3 4 5 6 7 7 7 6 5 4 3 2 1;
     1 2 3 4 5 6 7 8 7 6 5 4 3 2 1;
     1 2 3 4 5 6 7 7 7 6 5 4 3 2 1;
     1 2 3 4 4 5 6 6 6 5 4 4 3 2 1;
     0 1 2 3 4 4 5 5 5 4 4 3 2 1 0;
     0 1 2 2 3 4 4 4 4 4 3 2 2 1 0;
     0 0 1 2 2 3 3 3 3 3 2 2 1 0 0;
     0 0 0 1 1 2 2 2 2 2 1 1 0 0 0;
     0 0 0 0 0 1 1 1 1 1 0 0 0 0 0];
 
for i = 1:size(possibleEyesPos,1)
    varX = possibleEyesPos(i,1);
    varY = possibleEyesPos(i,2);
    A(varX-7:varX+7,varY-7:varY+7) = A(varX-7:varX+7,varY-7:varY+7) + M;
end

S = struct2cell(regionprops(bwconncomp(A),'Centroid'));
sS = size(S);

for i=1:sS(2)-1
    for j=i+1:sS(2)
        aux = abs(S{1,i}(1) - S{1,j}(1));
        if (aux < 10)
            firstEyeCenter = [S{1,i}(2), S{1,i}(1)];
            secondEyeCenter = [S{1,j}(2), S{1,j}(1)];
        end
    end
end


%% Prints the results

markedRGB = insertMarker(RGB, [firstEyeCenter;secondEyeCenter], 'color','green'); 
imshow(markedRGB);




