%% Cleans console and Workspace

clc;
clear;

%% Creates a classifier for detecting images with eyes

% Loads the features of the training dataset
load('..\..\data\gazeClassification\datasetFeatures.mat');

% Creates the classifier 
classifierTreeBagger = TreeBagger(100, trainingFeatures, trainingClasses); % TreeBagger

%% Saves the classifier
save('../../data/gazeClassification/gazeClassifier.mat', 'classifierTreeBagger'); 