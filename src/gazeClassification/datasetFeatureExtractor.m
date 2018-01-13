%% Cleans console and Workspace

clc;
clear;

%% Feature extraction

% Loads the images
load('..\..\data\gazeClassification\datasetImages.mat');

featureExtractor = featureExtractor();

% Creates the training feature matrix

trainingFeatures = featureExtractor.extractFeatures(trainingDataset);

% Creates the training classes vector

trainingClasses = [repmat('E',1,numTrainingLookingImages), repmat('N',1,numTrainingNotLookingImages)]';

% Creates the testing feature matrix

testingFeatures = featureExtractor.extractFeatures(testingDataset);

% Creates the testing classes vector

numTestingLookingImages = numImagesLooking - numTrainingLookingImages;
numTestingNotLookingImages = numImagesNotLooking - numTrainingNotLookingImages;

testingClasses = [repmat('E',1,numTestingLookingImages), repmat('N',1,numTestingNotLookingImages)]';

%% Saves the features and classes of training and testing datasets

save('../../data/gazeClassification/datasetFeatures.mat', 'trainingFeatures', 'trainingClasses', 'testingFeatures', 'testingClasses');
    