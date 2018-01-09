%% Cleans console and Workspace

clc;
clear;

%% Feature extraction

% Loads the images
load('..\..\data\eyeClassification\datasetImages.mat');

featureExtractor = featureExtractor();

% Creates the training feature matrix

trainingFeatures = featureExtractor.extractFeatures(trainingDataset);

% Creates the training classes vector

trainingClasses = [repmat('E',1,numTrainingEyesImages), repmat('N',1,numTrainingNoEyesImages)]';

% Creates the testing feature matrix

testingFeatures = featureExtractor.extractFeatures(testingDataset);

% Creates the testing classes vector

numTestingEyesImages = numImagesWithEyes - numTrainingEyesImages;
numTestingNoEyesImages = numImagesWithoutEyes - numTrainingNoEyesImages;

testingClasses = [repmat('E',1,numTestingEyesImages), repmat('N',1,numTestingNoEyesImages)]';

%% Saves the features and classes of training and testing datasets

save('../../data/eyeClassification/datasetFeatures.mat', 'trainingFeatures', 'trainingClasses', 'testingFeatures', 'testingClasses');
    