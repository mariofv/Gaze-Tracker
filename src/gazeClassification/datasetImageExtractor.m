%% Cleans console and Workspace

clc;
clear;

%% Extracts images with eyes and classify by gazeLabels (looking or not to camera)

imagesNames = dir ('..\..\data\originalDataset\*.pgm');
imagesEyesCoordinates = dir ('..\..\data\originalDataset\*.eye');
load('..\..\data\gazeLabels.mat');

numImages = length(imagesNames);
numImagesLooking = sum(gazeLabels)*2;
numImagesNotLooking = 2*numImages - numImagesLooking;

imagesLooking = zeros([64,64,numImagesLooking]);
imagesNotLooking = zeros([64,64,numImagesNotLooking]);

i_Looking = 1; % Index for save data
i_NotLooking = 1; % Index for save data

for i=1:numImages
    % Gets raw image dimensions
    
    imName = imagesNames(i).name;
    im = imread(strcat('..\..\data\originalDataset\', imName));
    [y,x] = size(im);
    
    % Gets eye coordinates
    
    eyesCoordinatesName = imagesEyesCoordinates(i).name;
    eyesCoordinatesFile = fopen(strcat('..\..\data\originalDataset\', eyesCoordinatesName));
    
    textscan(eyesCoordinatesFile,'%s %s %s %s', 1); % Needed in order to discard the headers of eyes coordinates file
    
    imCoord = textscan(eyesCoordinatesFile,'%d %d %d %d',1); 
    imCoord = double(cell2mat(imCoord));
    
    fclose(eyesCoordinatesFile);
    
    % Extraction of images with eyes 
    
    dist = uint16(abs(imCoord(3)-imCoord(1))*0.325);
    
    % Eye 1 
    left = max(1, imCoord(1) - dist); 
    right = min(x, imCoord(1) + dist);
    up = max(1, imCoord(2) - dist); 
    down = min(y, imCoord(2) + dist);
    
    % Eye 2
    left2 = max(1, imCoord(3) - dist); 
    right2 = min(x, imCoord(3) + dist);
    up2 = max(1, imCoord(4) - dist); 
    down2 = min(y, imCoord(4) + dist);
    
    if gazeLabels(i)
        imagesLooking(:,:, i_Looking*2-1) = imresize(im(up:down, left:right), [64,64]);
        imagesLooking(:,:, i_Looking*2) = imresize(im(up2:down2, left2:right2), [64,64]);
        i_Looking = i_Looking + 1;
    else
        imagesNotLooking(:,:, i_NotLooking*2-1) = imresize(im(up:down, left:right), [64,64]);
        imagesNotLooking(:,:, i_NotLooking*2) = imresize(im(up2:down2, left2:right2), [64,64]);
        i_NotLooking = i_NotLooking + 1;
    end  
end

%% Splits the images in training dataset and testing dataset

% Randomize the sample
lookIndex = randsample(numImagesLooking, numImagesLooking);
notLookIndex = randsample(numImagesNotLooking, numImagesNotLooking);

% Training and testing dataset

numTrainingLookingImages = floor(numImagesLooking*7/10);
numTrainingNotLookingImages = floor(numImagesNotLooking*7/10);

trainingDataset = cat(3,imagesLooking(:,:,lookIndex(1:numTrainingLookingImages)), imagesNotLooking(:,:,notLookIndex(1:numTrainingNotLookingImages)));
testingDataset = cat(3,imagesLooking(:,:,lookIndex(numTrainingLookingImages+1:end)), imagesNotLooking(:,:,notLookIndex(numTrainingNotLookingImages+1:end)));

%% Saves the images of training and testing datasets

save('../../data/gazeClassification/datasetImages.mat', 'trainingDataset', 'testingDataset', 'numTrainingLookingImages', 'numTrainingNotLookingImages', 'numImagesLooking', 'numImagesNotLooking');
