%% Cleans console and Workspace

clc;
clear;

%% Classifying images with eyes
load('..\..\data\look.mat');
imagesNames = dir ('..\..\data\classifierConstructorDataset\*.pgm');
imagesEyesCoordinates = dir ('..\..\data\classifierConstructorDataset\*.eye');
numImages = length(imagesNames);

%imagesLooking = zeros([1,numImages]);


%Jordi = 1:1500

for i=1501:numImages
    % Gets raw image dimensions
    
    imName = imagesNames(i).name;
    im = imread(strcat('..\..\data\classifierConstructorDataset\', imName));
    imshow(im,[]);
    
    % Get var from keyborad
    
    imagesLooking(i) = input('Looking? (1 = yes / 0 = no)');
    
end

save('../..\data/look.mat', 'imagesLooking'); 